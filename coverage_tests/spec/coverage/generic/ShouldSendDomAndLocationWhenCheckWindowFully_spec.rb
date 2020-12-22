# Generated by Ruby template


RSpec.describe 'Coverage Tests' do
  
  before :example do
    @driver = Selenium::WebDriver.for :remote, desired_capabilities: {'browserName' => 'chrome', 'goog:chromeOptions' => {'args' => %w[--disable-gpu --headless]}}
    @eyes = eyes(is_visual_grid: nil, is_css_stitching: false, branch_name: nil)
  end
  after :example do
    @driver.quit
    @eyes.abort
  end
  it 'ShouldSendDomAndLocationWhenCheckWindowFully' do
    @driver.get('https://applitools.github.io/demo/TestPages/FramesTestPage/')
    @eyes.configure do |conf|
    conf.app_name = 'Applitools Eyes SDK'
    conf.test_name = 'ShouldSendDomAndLocationWhenCheckWindowFully'
    conf.viewport_size = Applitools::RectangleSize.new(700, 460)
  end
    @eyes.open(driver: @driver)
    @driver.execute_script('window.scrollTo(0, 350)')
    @eyes.check(Applitools::Selenium::Target.window.fully)
    result = @eyes.close(false)
    info = get_test_info(result)
    expect(info['actualAppOutput'][0]['image']['location']).to eql({"x" => 0, "y" => 0})
    expect(info['actualAppOutput'][0]['image']['hasDom']).to eql(true)
    dom = get_dom(result, info['actualAppOutput'][0]['image']['domId'])
    expect(dom['attributes']['data-applitools-scroll']).to eql('true')
  end
end
