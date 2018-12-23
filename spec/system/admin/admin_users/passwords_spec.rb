require 'rails_helper'

RSpec.describe '管理画面：管理者アカウント：パスワード', type: :system do
  describe 'パスワードリセット画面' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    context '未ログイン' do
      it 'メールアドレスを入力後「パスワードの再設定方法を送信する」ボタンを押すとパスワードリセットメールが送信される' do
        visit new_admin_user_password_path
        fill_in 'admin_user[email]', with: admin_user.email
        click_on 'パスワードの再設定方法を送信する'
        expect(current_path).to eq(new_admin_user_session_path)
        expect(ApplicationMailer.deliveries.size).to eq(1)

        mail = ApplicationMailer.deliveries.last
        expect(mail.to).to include(admin_user.email)
        expect(mail.subject).to eq('パスワードの再設定について')
      end
    end
  end
end
