require 'okura/serializer'
dict_dir = 'lib/okura-dic'
tagger   = Okura::Serializer::FormatInfo.create_tagger dict_dir

text = '分かち書き対象のテキストです....慈悲はない...'
p tagger.wakati(text)
