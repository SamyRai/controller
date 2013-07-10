HTTP_TEST_STATUSES = {
  100 => 'Continue',
  101 => 'Switching Protocols',
  102 => 'Processing (WebDAV) (RFC 2518)',
  103 => 'Checkpoint',
  122 => 'Request-URI too long',
  200 => 'OK',
  201 => 'Created',
  202 => 'Accepted',
  203 => 'Non-Authoritative Information',
  204 => 'No Content',
  205 => 'Reset Content',
  206 => 'Partial Content',
  207 => 'Multi-Status (WebDAV) (RFC 4918)',
  208 => 'Already Reported (WebDAV) (RFC 5842)',
  226 => 'IM Used (RFC 3229)',
  300 => 'Multiple Choices',
  301 => 'Moved Permanently',
  302 => 'Found',
  303 => 'See Other',
  304 => 'Not Modified',
  305 => 'Use Proxy',
  306 => 'Switch Proxy',
  307 => 'Temporary Redirect',
  308 => 'Resume Incomplete',
  400 => 'Bad Request',
  401 => 'Unauthorized',
  402 => 'Payment Required',
  403 => 'Forbidden',
  404 => 'Not Found',
  405 => 'Method Not Allowed',
  406 => 'Not Acceptable',
  407 => 'Proxy Authentication Required',
  408 => 'Request Timeout',
  409 => 'Conflict',
  410 => 'Gone',
  411 => 'Length Required',
  412 => 'Precondition Failed',
  413 => 'Request Entity Too Large',
  414 => 'Request-URI Too Long',
  415 => 'Unsupported Media Type',
  416 => 'Requested Range Not Satisfiable',
  417 => 'Expectation Failed',
  418 => 'I\'m a teapot (RFC 2324)',
  420 => 'Enhance Your Calm',
  422 => 'Unprocessable Entity (WebDAV) (RFC 4918)',
  423 => 'Locked (WebDAV) (RFC 4918)',
  424 => 'Failed Dependency (WebDAV) (RFC 4918)',
  426 => 'Upgrade Required (RFC 2817)',
  428 => 'Precondition Required',
  429 => 'Too Many Requests',
  431 => 'Request Header Fields Too Large',
  444 => 'No Response',
  449 => 'Retry With',
  450 => 'Blocked by Windows Parental Controls',
  451 => 'Wrong Exchange server',
  499 => 'Client Closed Request',
  500 => 'Internal Server Error',
  501 => 'Not Implemented',
  502 => 'Bad Gateway',
  503 => 'Service Unavailable',
  504 => 'Gateway Timeout',
  505 => 'HTTP Version Not Supported',
  506 => 'Variant Also Negotiates (RFC 2295)',
  507 => 'Insufficient Storage (WebDAV) (RFC 4918)',
  508 => 'Loop Detected (WebDAV) (RFC 5842)',
  509 => 'Bandwidth Limit Exceeded (Apache bw\/limited extension)',
  510 => 'Not Extended (RFC 2774)',
  511 => 'Network Authentication Required',
  598 => 'Network read timeout error',
  599 => 'Network connect timeout error'
}

class TestController
  include Lotus::Controller

  action 'Index' do
    expose :xyz

    def call(params)
      @xyz = params[:name]
    end
  end
end

class CallAction
  include Lotus::Action

  def call(params)
    self.status  = 201
    self.body    = 'Hi from TestAction!'
    self.headers.merge!({ 'X-Custom' => 'OK' })
  end
end

class ErrorCallAction
  include Lotus::Action

  def call(params)
    raise
  end
end

class ExposeAction
  include Lotus::Action

  expose :film, :time

  def call(params)
    @film = '400 ASA'
  end
end

class BeforeMethodAction
  include Lotus::Action

  expose :article
  before :set_article, :reverse_article

  def call(params)
  end

  private
  def set_article
    @article = 'Bonjour!'
  end

  def reverse_article
    @article.reverse!
  end
end

class SubclassBeforeMethodAction < BeforeMethodAction
  before :upcase_article

  private
  def upcase_article
    @article.upcase!
  end
end

class ParamsBeforeMethodAction < BeforeMethodAction
  expose :exposed_params

  private
  def set_article(params)
    @exposed_params = params
    @article = super() + params[:bang]
  end
end

class ErrorBeforeMethodAction < BeforeMethodAction
  private
  def set_article
    raise
  end
end

class BeforeBlockAction
  include Lotus::Action

  expose :article
  before { @article = 'Good morning!' }
  before { @article.reverse! }

  def call(params)
  end
end

class YieldBeforeBlockAction < BeforeBlockAction
  expose :yielded_params
  before {|params| @yielded_params = params }
end

class AfterMethodAction
  include Lotus::Action

  expose :egg
  after  :set_egg, :scramble_egg

  def call(params)
  end

  private
  def set_egg
    @egg = 'Egg!'
  end

  def scramble_egg
    @egg = 'gE!g'
  end
end

class SubclassAfterMethodAction < AfterMethodAction
  after :upcase_egg

  private
  def upcase_egg
    @egg.upcase!
  end
end

class ParamsAfterMethodAction < AfterMethodAction
  private
  def scramble_egg(params)
    @egg = super() + params[:question]
  end
end

class ErrorAfterMethodAction < AfterMethodAction
  private
  def set_egg
    raise
  end
end

class AfterBlockAction
  include Lotus::Action

  expose :egg
  after { @egg = 'Coque' }
  after { @egg.reverse! }

  def call(params)
  end
end

class YieldAfterBlockAction < AfterBlockAction
  expose :meaning_of_life_params
  before {|params| @meaning_of_life_params = params }
end

class SessionAction
  include Lotus::Action

  def call(params)
  end
end

class RedirectAction
  include Lotus::Action

  def call(params)
    redirect_to '/destination'
  end
end

class StatusRedirectAction
  include Lotus::Action

  def call(params)
    redirect_to '/destination', status: 301
  end
end

class ClassAttributeTest
  include Lotus::Utils::ClassAttribute

  class_attribute :callbacks, :functions, :values
  self.callbacks = [:a]
  self.values    = [1]
end

class SubclassAttributeTest < ClassAttributeTest
  self.functions = [:x, :y]
end

class GetCookiesAction
  include Lotus::Action

  def call(params)
  end
end

class SetCookiesAction
  include Lotus::Action

  def call(params)
    self.body = 'yo'
    cookies[:foo] = 'yum!'
  end
end

class SetCookiesWithOptionsAction
  include Lotus::Action

  def call(params)
    cookies[:kukki] = { value: 'yum!', domain: 'lotusrb.org', path: '/controller', expires: params[:expires], secure: true, httponly: true }
  end
end

class RemoveCookiesAction
  include Lotus::Action

  def call(params)
    cookies[:rm] = nil
  end
end

class ThrowCodeAction
  include Lotus::Action

  def call(params)
    throw params[:status]
  end
end

class ThrowBeforeMethodAction
  include Lotus::Action

  before :authorize!
  before :set_body

  def call(params)
    self.body = 'Hello!'
  end

  private
  def authorize!
    throw 401
  end

  def set_body
    self.body = 'Hi!'
  end
end

class ThrowBeforeBlockAction
  include Lotus::Action

  before { throw 401 }
  before { self.body = 'Hi!' }

  def call(params)
    self.body = 'Hello!'
  end
end

class ThrowAfterMethodAction
  include Lotus::Action

  after :raise_timeout!
  after :set_body

  def call(params)
    self.body = 'Hello!'
  end

  private
  def raise_timeout!
    throw 408
  end

  def set_body
    self.body = 'Later!'
  end
end

class ThrowAfterBlockAction
  include Lotus::Action

  after { throw 408 }
  after { self.body = 'Later!' }

  def call(params)
    self.body = 'Hello!'
  end
end

class ParamsAction
  include Lotus::Action

  def call(params)
    self.body = params.inspect
  end
end

class Root
  include Lotus::Action

  def call(params)
    self.body = params
    headers.merge!({'X-Test' => 'test'})
  end
end

class AboutController
  include Lotus::Controller

  class Team < Root
  end

  action 'Contacts' do
    def call(params)
      self.body = params
    end
  end
end

class IdentityController
  include Lotus::Controller

  class Action
    include Lotus::Action

    def call(params)
      self.body = params
    end
  end

  Show    = Class.new(Action)
  New     = Class.new(Action)
  Create  = Class.new(Action)
  Edit    = Class.new(Action)
  Update  = Class.new(Action)
  Destroy = Class.new(Action)
end

class FlowersController
  include Lotus::Controller

  class Action
    include Lotus::Action

    def call(params)
      self.body = params
    end
  end

  Index   = Class.new(Action)
  Show    = Class.new(Action)
  New     = Class.new(Action)
  Create  = Class.new(Action)
  Edit    = Class.new(Action)
  Update  = Class.new(Action)
  Destroy = Class.new(Action)
end
