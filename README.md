# foodShopHelper

## 概要

レシピをランダム表示して買い物の手助けをするアプリ。
良いと思ったものを、今日の献立に追加していくことで、必要な材料の一覧がわかって便利！

### なぜ作ったか

- レシピを考える余裕がないくらい疲れているときは、買い物の際にレシピを検索する気力すら沸かない場合が多い
- このような場合に、ランダムに表示されたレシピの中から選択したものの材料がわかると買い物も実際の料理も楽になる！

## 使い方

* install swift playgrounds on your iPad or Mac
* download FoodShopHelper.swiftpm from this repository and load to swift playgrouds
* open FoodShopeHelper and run

## 機能

チェック済みのものが現在の機能で、チェック無しのものはこれから作りたい機能

### ランダムレシピ (RandomRecipeView)

- [x]  楽天APIからレシピ情報取得
- [x]  画像の遅延表示
- [x]  ボタンタップでランダムなレシピ表示（タイトル、画像、説明）
- [x]  ボタンタップで表示されたレシピを今日の献立に追加

### 今日の献立 (TodayCourseView)

- [x]  今日の献立のリスト表示
- [x]  今日の献立からレシピを削除
- [x]  リスト表示した各レシピの詳細表示
- [x]  材料のリスト表示（重複を省く）
- [ ]  リセット（全て削除）
- [ ]  材料の合計量表示（楽天レシピのAPIでは取得できないので、ここも変える必要がある）
- [ ]  人数に応じた合計量表示（そのためのUIが必要）
- [ ]  レシピリストにおいてLazyVGridの利用（タイル表示の方がクールかもしれない）
- [ ]  各レシピの表示をNavigationを使ってNotionのUIのような感じで画面全体に表示する（現状、リスト内だけでレシピを確認するのは画面が小さいため）
- [ ]  削除機能の代替手段として長押しからメニュー表示で削除できるようにする（https://developer.apple.com/jp/design/human-interface-guidelines/accessibility に準拠する）

### お気に入り (FavoriteListView)

- [ ]  献立のデータベース保存
- [ ]  ボタンタップできょうの料理に追加
- [ ]  オリジナルレシピの追加・編集

### 紹介動画

https://github.com/b-sakai/foodShopHelper/assets/25577220/045408d2-2fef-4199-9214-21ccd1763958

## 技術的に工夫した点

- デザイン
    - Tiktokのような画面下半分にボタンが集まるUI設計（最近のスマートフォンの大型化に対するプラクティス）
- 技術
    - 画像の遅延表示のために、ObservableObjectを利用
    - 毎度通信をしないように画像をキャッシュ
    - 非同期通信にSwift Concurrency (async / await)を利用

## 苦労した点（忘備録）

- 「Build failed Macho-O can’t be generated」というエラーが出ていたが、これは誤ってAppを継承した構造体を定義したファイルを消してしまったからだった。。。。。
- 重複なしリストを使うために、Swift PackageのOrderdCollectionsに含まれるOrderedSetの利用を考えたが、リスト表示を行う関係上配列の方が扱いやすかったために断念した。
    - ForEachでid: .\selfが上手く取得できなかったため
- Decoding JSONエラー
    - 単純なエラーだったが、細かいエラーがでない場合があり、いきなり複雑なものを書いてしまったせいで、かなり詰まってしまった






