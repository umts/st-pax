require 'prawn/table'

class PrintRecordPdf < Prawn::Document
  def initialize
    super()
    content_width = bounds.width - 10
    mycooltable
  end

  def mycooltable
    table([ ["hello", "my", "name", "is", "ava"],
      ["this", "is", "my", "table", ""]
      ]
    )
  end
