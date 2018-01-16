require_relative '../test_helper'

class DataFileTest < Test
  def test_parse_simple
    sample = <<-EOS
      Line 1
      Line 2
      Line 3
      Line 4
    EOS
    assert_equal({default: sample}, Werkzeug::DataFile.parse(sample))
  end

  def test_parse_files
    result = Werkzeug::DataFile.parse <<~EOS
      default_line_1
      default_line_2
      default_line_3
      @@ file_2
      file_2_line_1
      file_2_line_2
      file_2_line_3
      @@ file_3
      file_3_line_1
      file_3_line_2
      file_3_line_3
    EOS
    assert_equal(%i[default file_2 file_3], result.keys)
    assert_equal("default_line_1\ndefault_line_2\ndefault_line_3\n", result[:default])
    assert_equal("file_2_line_1\nfile_2_line_2\nfile_2_line_3\n", result[:file_2])
    assert_equal("file_3_line_1\nfile_3_line_2\nfile_3_line_3\n", result[:file_3])
  end

  def test_read
    result = Werkzeug::DataFile.read
    exp = {
      default: '',
      file1: "file_1_line_1\nfile_1_line_2\nfile_1_line_3\n",
      file2: "file_2_line_1\nfile_2_line_2\nfile_2_line_3\n"
    }
    assert_equal(exp, result)
  end

  def test_fail
    assert_raises_message(ArgumentError, 'each_line') do
      Werkzeug::DataFile.parse(:does_not_respond_to_each_line)
    end
  end
end
__END__
@@ file1
file_1_line_1
file_1_line_2
file_1_line_3
@@ file2
file_2_line_1
file_2_line_2
file_2_line_3
