require "selenium-webdriver"
include Selenium
include Selenium::WebDriver

cfile = ARGV[0]
pageToLike = ARGV[1]
numPosts = ARGV[2].to_i

wait = Wait.new(:timeout => 30000)

options = Chrome::Options.new()
options.add_argument('--disable-notifications')
options.add_argument('start-maximized')
driver = WebDriver.for(:chrome, options: options)

file = File.read(cfile)
map = JSON.parse(file)
user = map['user']
pwd = map['pwd']

driver.get("http://facebook.com")
wait.until {driver.find_element(:css, "#email")}

email = driver.find_element(:css, "#email")
email.send_keys(user)

pass = driver.find_element(:css, "#pass")
pass.send_keys(pwd)

login = driver.find_element(:css, "#loginbutton")
login.click()
wait.until {driver.find_element(:css, "[data-testid=search_input]")}

search = driver.find_element(:css, "[data-testid=search_input]")
search.send_keys(pageToLike)
search.send_keys(:arrow_down)
search.send_keys(:enter)
wait.until {driver.find_element(:css, "div._6v_0._4ik4._4ik5 a")}

pagelink = driver.find_element(:css, "div._6v_0._4ik4._4ik5 a")
pagelink.click()
wait.until {driver.find_element(:css, "[data-key=tab_posts]")}

postlink = driver.find_element(:css, "[data-key=tab_posts]")
postlink.click()

wait.until {driver.find_element(:css, "#pagelet_timeline_main_column ._1xnd > ._4-u2._4-u8")}

idx = 0;

while (idx < numPosts) 
    wait.until {driver.find_element(:css, '.uiMorePagerLoader')}
    wait.until {driver.find_element(:css, '.uiMorePagerLoader').css_value('display') == 'none'}

    wait.until {driver.find_elements(:css, "#pagelet_timeline_main_column ._1xnd > ._4-u2._4-u8")}
    elements = driver.find_elements(:css, '#pagelet_timeline_main_column ._1xnd > ._4-u2._4-u8')
    
    wait.until {elements[idx].find_element(:css, "._666k")}
    toClick = elements[idx].find_element(:css, '._666k');
    toClick.click();

    idx = idx + 1

    if(idx == elements.length)
        driver.execute_script("window.scrollTo(0, document.body.clientHeight)")
        # wait.until {driver.find_element(:css, '.uiMorePagerLoader')}
        # wait.until {driver.find_element(:css, '.uiMorePagerLoader').css_value('display') == 'none'}
        sleep 2
    end
end


