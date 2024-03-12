# frozen_string_literal: true

class SoygaTable
  ALPHABET = 'abcdefghiklmnopqrstuxyz'.chars
  F_VALUES = {
    'a' => 2, 'b' => 2, 'c' => 3, 'd' => 5, 'e' => 14,
    'f' => 2, 'g' => 6, 'h' => 5, 'i' => 14, 'k' => 15,
    'l' => 20, 'm' => 22, 'n' => 14, 'o' => 8, 'p' => 13,
    'q' => 20, 'r' => 11, 's' => 8, 't' => 8, 'u' => 15,
    'x' => 15, 'y' => 15, 'z' => 2
  }.freeze
  SIZE = 36

  def initialize(input)
    sanitized_input = sanitize_input(input)
    unless sanitized_input
      raise ArgumentError,
            'Invalid. Provide a string of 2-10 letters in the Classical Latin ' \
            'alphabet without spaces or non-letter characters.'
    end

    @code_word = sanitized_input.downcase.chars
    @table = Array.new(SIZE) { Array.new(SIZE) }
  end

  def print_table
    fill_left_column
    fill_top_row
    fill_interior
    @table.each do |row|
      puts row.join(' ')
    end
  end

  def sanitize_input(input)
    return nil unless /^[a-zA-Z]{2,10}$/.match?(input)

    input.tr('jvwJWV', 'iiuuUU').downcase.chars.select { |char| ALPHABET.include?(char) }.join
  end

  def letter_to_number(letter)
    ALPHABET.index(letter) + 1
  end

  def number_to_letter(number)
    ALPHABET[(number - 1) % ALPHABET.size]
  end

  def f(letter)
    F_VALUES[letter]
  end

  def fill_left_column
    pattern = @code_word + @code_word.reverse
    (0...SIZE).each do |row|
      @table[row][0] = pattern[row % pattern.size]
    end
  end

  def fill_top_row
    (1...SIZE).each do |col|
      left_letter = @table[0][col - 1]
      number = (letter_to_number(left_letter) + f(left_letter)) % ALPHABET.size
      @table[0][col] = number_to_letter(number)
    end
  end

  def fill_interior
    (1...SIZE).each do |row|
      (1...SIZE).each do |col|
        n = letter_to_number(@table[row - 1][col])
        w = @table[row][col - 1]
        @table[row][col] = number_to_letter((n + f(w)) % ALPHABET.size)
      end
    end
  end
end

soyga_keywords = %w(
  NISRAM ROELER IOMIOT ISIAPO ORRASE OSACUE XUAUIR RAOSAC RSADUA
  ATROGA SDUOLO ARICAA MARSIN RELEOR TOIMOI OPAISI ESARRO EUCASO
  RIUAUX CASOAR AUDASR AGORTA OLOUDS AACIRA OSRESO NIEBOA OIAIAE
  ITIABA ADAMIS REUELA UISEUA MERONF ILIOSU OYNIND IASULA MOYSES
)

inputs = ARGV

# if no input is provided, all Soyga Keywords are used
inputs = soyga_keywords if inputs.empty?

inputs.each do |word|
  puts "\nSoyga table for keyword: #{word}\n\n"
  table = SoygaTable.new(word)
  table.print_table
end
