require 'rails_helper'

RSpec.describe '管理画面：管理者アカウント：セッション', type: :system do
  let!(:admin_user) { FactoryBot.create(:admin_user) }

  describe 'ログイン画面' do
    context '未ログイン' do
      it 'アカウント情報を入力し「ログイン」ボタンを押すとログインできる' do
        visit new_admin_user_session_path
        fill_in 'admin_user[email]', with: admin_user.email
        fill_in 'admin_user[password]', with: admin_user.password
        check 'admin_user[remember_me]'
        click_on 'ログイン'
        expect(current_path).to eq(admin_root_path)
      end

      it '入力内容に不備があるとエラーメッセージが表示される' do
        visit new_admin_user_session_path
        click_on 'ログイン'
        expect(current_path).to eq(new_admin_user_session_path)
        expect(find('.flash-alert')).to have_content(I18n.t('devise.failure.invalid'))
      end

      it '「パスワードを忘れましたか?」リンクをクリックするとパスワードリセット画面に遷移する' do
        visit new_admin_user_session_path
        click_on 'パスワードを忘れましたか?'
        expect(current_path).to eq(new_admin_user_password_path)
      end
    end

    context 'ログイン済み' do
      before do
        sign_in admin_user
      end

      it 'アクセスできない' do
        visit new_admin_user_session_path
        expect(current_path).to eq(admin_root_path)
      end
    end
  end

  describe 'ログアウト' do
    before do
      sign_in admin_user
    end

    it 'ヘッダメニューの「ログアウト」リンクを押すとログアウトする' do
      visit admin_facilities_path
      click_on 'ログアウト'
      expect(current_path).to eq(new_admin_user_session_path)
      expect(find('.flash-notice')).to have_content(I18n.t('devise.sessions.signed_out'))
    end
  end
end
