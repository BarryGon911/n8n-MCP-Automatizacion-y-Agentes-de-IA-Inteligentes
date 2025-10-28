import puppeteer from 'puppeteer';
import * as cheerio from 'cheerio';
import axios from 'axios';

export class WebScraperService {
  async scrape(url: string, selector?: string): Promise<any> {
    try {
      // First try simple HTTP request
      const simpleResult = await this.simpleScrape(url, selector);
      if (simpleResult.success) {
        return simpleResult;
      }

      // Fallback to Puppeteer for JavaScript-heavy sites
      return await this.browserScrape(url, selector);
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  private async simpleScrape(url: string, selector?: string): Promise<any> {
    try {
      const response = await axios.get(url, {
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      });

      const $ = cheerio.load(response.data);

      if (selector) {
        const content = $(selector).text().trim();
        return {
          success: true,
          content,
          url,
          method: 'simple',
        };
      }

      // Extract main content
      const title = $('title').text();
      const metaDescription = $('meta[name="description"]').attr('content');
      const bodyText = $('body').text().replace(/\s+/g, ' ').trim();

      return {
        success: true,
        title,
        description: metaDescription,
        content: bodyText.substring(0, 5000), // Limit content
        url,
        method: 'simple',
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  private async browserScrape(url: string, selector?: string): Promise<any> {
    let browser;
    try {
      browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
      });

      const page = await browser.newPage();
      await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
      await page.goto(url, { waitUntil: 'networkidle2', timeout: 30000 });

      let content;
      if (selector) {
        content = await page.$eval(selector, (el) => el.textContent?.trim() || '');
      } else {
        content = await page.evaluate(() => {
          return {
            title: document.title,
            description: document.querySelector('meta[name="description"]')?.getAttribute('content'),
            body: document.body.innerText.substring(0, 5000),
          };
        });
      }

      await browser.close();

      return {
        success: true,
        content,
        url,
        method: 'browser',
      };
    } catch (error) {
      if (browser) {
        await browser.close();
      }
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async scrapeMultiple(urls: string[]): Promise<any[]> {
    const results = await Promise.allSettled(
      urls.map((url) => this.scrape(url))
    );

    return results.map((result, index) => {
      if (result.status === 'fulfilled') {
        return result.value;
      }
      return {
        success: false,
        url: urls[index],
        error: result.reason.message,
      };
    });
  }
}
