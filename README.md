# たてや組 README

たてや組 公式ウェブページは[XHTML 5の仕様](http://www.w3.org/TR/html5/)に沿って書かれた文書を素材とし、XSLTスタイルシートを使用して[XHTML 1.0 Strictの仕様](http://www.w3.org/TR/xhtml1/)に沿った文書に変換するようにしています。

この仕組みは`make`を使って実現されており`make`コマンドと`xsltproc`コマンドが使用可能な環境であれば拡張子が.xhtmlとなっているファイルを編集した後に`make`とターミナルから入力するだけで全ての工程を自動で実行なされるようになっております。

XHTML 1.0 Strictの仕様に沿うように変換しているのはInternet Explorerは8以下のバージョンでは未知の要素に対してスタイルシートの適用が行われない為であり、あくまで暫定的な処置となっております。

## 記述の基本ルール

[W3Cに仕様](http://www.w3.org/TR/html5/)から外れない範囲であれば自由に書いて貰っても構いませんが、一つだけ属性は属性名をアルファベット順に並べるようにして下さい。一つづつの要素に一つづづ統一的なルールを設けるのは手間がかかるのでこうしていますが、何か明確な指針のような物が公開されているのであれば示して貰えると助かります。

また文書の新規に作成した場合は作成日時を`head`要素内に`<meta content="1970-01-01T00:00:00Z" name="dcterms.created"/>`の形で示して下さい。日付けの書式は[W3C DTF](http://www.w3.org/TR/NOTE-datetime)に沿って下さい。タイムゾーンはJSTでも構いませんがUTCを使う事を強く奨励しています。また更新日時は`make`コマンドを使用すると自動で付与されますので文書を書く際に書く必要はありません。