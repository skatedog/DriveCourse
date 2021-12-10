require 'rails_helper'

describe "ユーザー関連機能・車両関連機能のテスト", type: :system do
  let!(:user) { create(:user) }
  before do
    visit root_path
  end
  context "ログイン前" do
    describe "ヘッダーの画面遷移機能" do
      context "トップページを押下" do
        before do
          click_on "トップページ"
        end
        it "トップページが表示される" do
          expect(current_path).to eq root_path
        end
      end
      context "検索を押下" do
        before do
          click_on "検索"
        end
        it "検索画面が表示される" do
          expect(current_path).to eq "/homes/search"
        end
      end
      context "ログインを押下" do
        before do
          click_link "ログイン"
        end
        it "ログインページが表示される" do
          expect(current_path).to eq "/users/sign_in"
        end
      end
      context "新規登録を押下" do
        before do
          click_link "新規登録", match: :first
        end
        it "新規登録画面が表示される" do
          expect(current_path).to eq "/users/sign_up"
        end
      end
    end
  end
  context "ログイン後" do
    before do
      fill_in "user[email]", with: user.email
      fill_in "user[password]", with: user.password
      click_button "ログイン"
    end
    it "マイページが表示される" do
      expect(current_path).to eq "/users/" + user.id.to_s
    end
    it "ユーザー情報が表示される" do
      expect(page).to have_content user.name
      expect(page).to have_content user.introduction
    end
    describe "ヘッダーの画面遷移機能" do
      context "マイページを押下" do
        before do
          click_on "マイページ"
        end
        it "マイページが表示される" do
          expect(current_path).to eq "/users/" + user.id.to_s
        end
      end
      context "検索を押下" do
        before do
          click_on "検　 索"
        end
        it "検索画面が表示される" do
          expect(current_path).to eq "/homes/search"
        end
      end
      context "プレイス登録を押下" do
        before do
          click_on "プレイス登録"
        end
        it "プレイス登録画面が表示される" do
          expect(current_path).to eq "/places"
        end
      end
      context "ドライブコース登録を押下" do
        before do
          click_on "ドライブコース登録"
        end
        it "ドライブコース登録画面が表示される" do
          expect(current_path).to eq "/courses/new"
        end
      end
      context "ログアウトを押下" do
        before do
          click_on "ログアウト"
        end
        it "トップページが表示される" do
          expect(current_path).to eq root_path
        end
      end
    end
    describe "ユーザー情報編集機能" do
      before do
        click_on "編集"
      end
      it "ユーザー情報編集画面が表示される" do
        expect(current_path).to eq "/users/" + user.id.to_s + "/edit"
      end
      it "公開設定が非公開になっている" do
        expect(page).to have_checked_field("非公開")
      end
      context "ユーザー名、メールアドレス、紹介文を修正する" do
        before do
          fill_in "user[name]", with: "update-name"
          fill_in "user[email]", with: "update@example.com"
          fill_in "user[introduction]", with: "update-introduction"
          click_button "登録"
        end
        it "マイページが表示される" do
          expect(current_path).to eq "/users/" + user.id.to_s
        end
        it "修正した内容が正しく反映されている" do
          expect(page).to have_content "update-name"
          expect(page).to have_content "update-introduction"
        end
      end
      context "退会する" do
        before do
          click_on "退会する"
        end
        it "トップページが表示される" do
          expect(current_path).to eq root_path
        end
        context "退会した情報でログインをする" do
          before do
            fill_in "user[email]", with: user.email
            fill_in "user[password]", with: user.password
            click_button "ログイン"
          end
          it "ログインに失敗し、ログイン画面が表示される" do
            expect(current_path).to eq "/users/sign_in"
          end
        end
      end
    end
    describe "車両関連機能" do
      describe "車関連機能" do
        before do
          page.all("a", text: "新規登録")[0].click
        end
        it "車の新規登録画面が表示される" do
          expect(page).to have_current_path "/vehicles/new?category=car"
        end
        it "hidden_fieldの値にcarが設定されている" do
          expect(find("#vehicle_category", visible: false).value).to eq "car"
        end
        describe "車の新規登録機能" do
          before do
            fill_in "vehicle[maker]", with: "vehicle-maker"
            fill_in "vehicle[displacement]", with: 1000
            fill_in "vehicle[name]", with: "vehicle-name"
            fill_in "vehicle[introduction]", with: "vehicle-introduction"
            click_button "登録"
          end
          it "マイページが表示される" do
            expect(current_path).to eq "/users/" + user.id.to_s
          end
          it "登録した車の情報が表示される" do
            expect(page).to have_content "vehicle-maker"
            expect(page).to have_content "vehicle-name"
            expect(page).to have_content 1000
            expect(page).to have_content "vehicle-introduction"
          end
          describe "車の情報編集機能" do
            before do
              page.all("a", text: "編集")[1].click
            end
            it "車の情報編集画面が表示される" do
              expect(current_path).to eq "/vehicles/" + Vehicle.last.id.to_s + "/edit"
            end
            context "車種、排気量、車名、紹介文を修正する" do
              before do
                fill_in "vehicle[maker]", with: "update-vehicle-maker"
                fill_in "vehicle[displacement]", with: 2000
                fill_in "vehicle[name]", with: "update-vehicle-name"
                fill_in "vehicle[introduction]", with: "update-vehicle-introduction"
                click_button "登録"
              end
              it "マイページが表示される" do
                expect(current_path).to eq "/users/" + user.id.to_s
              end
              it "修正した内容が正しく反映されている" do
                expect(page).to have_content "update-vehicle-maker"
                expect(page).to have_content "update-vehicle-name"
                expect(page).to have_content 2000
                expect(page).to have_content "update-vehicle-introduction"
              end
            end
            describe "車を削除する" do
              before do
                click_on "削除する"
              end
              it "マイページが表示される" do
                expect(current_path).to eq "/users/" + user.id.to_s
              end
              it "削除が完了し、車の情報が表示されない" do
                expect(page).to have_no_content "vehicle-name"
              end
            end
          end
        end
      end
      describe "バイク関連機能" do
        before do
          page.all("a", text: "新規登録")[1].click
        end
        it "バイクの新規登録画面が表示される" do
          expect(page).to have_current_path "/vehicles/new?category=motorcycle"
        end
        it "hidden_fieldの値にmotorcycleが設定されている" do
          expect(find("#vehicle_category", visible: false).value).to eq "motorcycle"
        end
        describe "バイクの新規登録機能" do
          before do
            fill_in "vehicle[maker]", with: "vehicle-maker"
            fill_in "vehicle[displacement]", with: 1000
            fill_in "vehicle[name]", with: "vehicle-name"
            fill_in "vehicle[introduction]", with: "vehicle-introduction"
            click_button "登録"
          end
          it "マイページが表示される" do
            expect(current_path).to eq "/users/" + user.id.to_s
          end
          it "登録したバイクの情報が表示される" do
            expect(page).to have_content "vehicle-maker"
            expect(page).to have_content "vehicle-name"
            expect(page).to have_content 1000
            expect(page).to have_content "vehicle-introduction"
          end
          describe "バイクの情報編集機能" do
            before do
              page.all("a", text: "編集")[1].click
            end
            it "バイクの情報編集画面が表示される" do
              expect(current_path).to eq "/vehicles/" + Vehicle.last.id.to_s + "/edit"
            end
            context "車種、排気量、車名、紹介文を修正する" do
              before do
                fill_in "vehicle[maker]", with: "update-vehicle-maker"
                fill_in "vehicle[displacement]", with: 2000
                fill_in "vehicle[name]", with: "update-vehicle-name"
                fill_in "vehicle[introduction]", with: "update-vehicle-introduction"
                click_button "登録"
              end
              it "マイページが表示される" do
                expect(current_path).to eq "/users/" + user.id.to_s
              end
              it "修正した内容が正しく反映されている" do
                expect(page).to have_content "update-vehicle-maker"
                expect(page).to have_content "update-vehicle-name"
                expect(page).to have_content 2000
                expect(page).to have_content "update-vehicle-introduction"
              end
            end
            describe "バイクを削除する" do
              before do
                click_on "削除する"
              end
              it "マイページが表示される" do
                expect(current_path).to eq "/users/" + user.id.to_s
              end
              it "削除が完了し、バイクの情報が表示されない" do
                expect(page).to have_no_content "vehicle-name"
              end
            end
          end
        end
      end
    end
  end
end