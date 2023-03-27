defmodule LoggerTest.TestLogger do
  require Logger

  def test do
	Logger.info("This is a custom logger message")
	Logger.warning("custom warning ?")
  end
end
