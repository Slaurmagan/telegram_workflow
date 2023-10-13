class TelegramWorkflow::Action
  extend ::Forwardable
  def_delegators :@__workflow, :client, :params, :redirect_to

  def initialize(workflow, session, flash)
    @__workflow = workflow
    @__session = session
    @__flash = flash
  end

  def shared
    :__continue
  end

  def on_redirect(&block)
    @on_redirect = block
  end

  def on_message(&block)
    @on_message = block
  end

  def on_callback(callback_data_whitelist: [], &block)
    @callback_data_whitelist = callback_data_whitelist
    @on_callback = block
  end

  def __reset_callbacks
    @on_redirect = @on_message = @on_callback = nil
  end

  def __run_on_redirect
    @on_redirect.call if @on_redirect
  end

  def __run_on_message
    @on_message.call if @on_message
  end

  def __run_on_callback
    @on_callback.call if on_callback? && callback_data_whitelisted?
  end

  def on_callback?
    @on_callback
  end

  private

  def callback_data_whitelisted?
    @callback_data_whitelist.include?(params.callback_data)
  end

  def session
    @__session
  end

  def flash
    @__flash
  end
end
