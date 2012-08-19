module Shortcode
  def self.new(length = 6)
    alphabet = %w(
      1 2 3 4 5 6 7 8 9
      1 2 3 4 5 6 7 8 9
      1 2 3 4 5 6 7 8 9
      a b c d e f g h i
      j k m n o p q r s
      t u v w x y z A B
      C D E F G H J K L
      M N P Q R S T U V
      W X Y Z
    )
    
    alphabet.shuffle[0,length] * ""
  end
end