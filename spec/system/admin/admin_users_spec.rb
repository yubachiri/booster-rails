require 'rails_helper'

RSpec.describe '管理画面：管理者アカウント管理', type: :system do
  describe '管理者アカウント一覧画面' do
    let!(:admin_users) { FactoryBot.create_list(:admin_user, 3) }

    context '未ログイン' do
      it 'アクセスできない' do
        visit admin_admin_users_path
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'ログイン済み' do
      before do
        sign_in admin_users.first
      end

      it '管理者アカウント一覧が表示される' do
        visit admin_admin_users_path
        within('.right_col') do
          expect(find('.title_left')).to have_content(I18n.t('admin.title.admin_users.index'))
          within('.x_panel tbody') do
            expect(all('tr').count).to eq(admin_users.count)
            all('tr').each_with_index do |tr, i|
              admin_user = admin_users[i]
              expect(tr).to have_content(admin_user.name)
              expect(tr).to have_content(admin_user.email)
              expect(tr.find('a', text: '詳細')['href']).to eq(admin_admin_user_path(admin_user))
            end
          end
        end
      end

      it '「新規作成」ボタンを押すと管理者アカウント新規作成画面に遷移する' do
        visit admin_admin_users_path
        within('.right_col .x_panel') do
          find('a', text: '新規作成').click
        end
        expect(current_path).to eq(new_admin_admin_user_path)
      end

      it '「詳細」ボタンを押すと管理者アカウント詳細画面に遷移する' do
        visit admin_admin_users_path
        within('.right_col .x_panel tbody') do
          first('tr').find('a', text: '詳細').click
        end
        expect(current_path).to eq(admin_admin_user_path(admin_users.first))
      end

      it '管理者アカウント一覧にパンくずリストが表示される' do
        visit admin_admin_users_path
        within('.right_col') do
          expect(find('.page-title')).to have_content(I18n.t('admin.title.admin_users.index'))
        end
      end
    end
  end

  describe '管理者アカウント詳細画面' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    context '未ログイン' do
      it 'アクセスできない' do
        visit admin_admin_user_path(admin_user)
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'ログイン済み' do
      before do
        sign_in admin_user
      end

      it '管理者アカウント詳細が表示される' do
        visit admin_admin_user_path(admin_user)
        within('.right_col') do
          expect(find('.title_left')).to have_content(admin_user.name)
          within('.x_panel') do
            expect(page).to have_content(admin_user.name)
            expect(page).to have_content(admin_user.email)
          end
        end
      end

      it '「編集」ボタンを押すと管理者アカウント編集画面に遷移する' do
        visit admin_admin_user_path(admin_user)
        within('.right_col') do
          find('a', text: '編集').click
        end
        expect(current_path).to eq(edit_admin_admin_user_path(admin_user))
      end

      it '「削除」ボタンを押すと管理者アカウントが削除される' do
        other_admin_user = FactoryBot.create(:admin_user)
        visit admin_admin_user_path(other_admin_user)
        within('.right_col') do
          find('a', text: '削除').click
        end
        expect(current_path).to eq(admin_admin_users_path)
        expect(find('.flash-notice')).to have_content(I18n.t('admin.messages.destroy.success'))
        expect { AdminUser.find(other_admin_user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it '詳細画面でもパンくずリストが表示される' do
        visit admin_admin_user_path(admin_user)
        within('.right_col') do
          expect(find('.title_right')).to have_link I18n.t('admin.title.admin_users.index'), href: admin_admin_users_path
          expect(find('.title_right')).to have_content(admin_user.name)
        end
      end

      it '詳細画面で管理者管理リンクをクリックすると、一覧画面に遷移する' do
        visit admin_admin_user_path(admin_user)
        find('.title_right').click_link I18n.t('admin.title.admin_users.index')
        expect(current_path).to eq (admin_admin_users_path)
      end
    end
  end

  describe '管理者アカウント新規作成画面' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    context '未ログイン' do
      it 'アクセスできない' do
        visit new_admin_admin_user_path
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'ログイン済み' do
      before do
        sign_in admin_user
      end

      it '各項目を入力後「新規作成」ボタンを押すと管理者アカウントが作成される' do
        visit new_admin_admin_user_path
        within('.right_col') do
          expect(find('.title_left')).to have_content(I18n.t('admin.actions.new'))
          within('.x_panel') do
            admin_user = FactoryBot.build(:admin_user)
            fill_in 'admin_user[name]', with: admin_user.name
            fill_in 'admin_user[email]', with: admin_user.email
            fill_in 'admin_user[password]', with: 'hogefuga'
            fill_in 'admin_user[password_confirmation]', with: 'hogefuga'
            click_on '登録する'
          end
        end
        expect(current_path).to eq(admin_admin_user_path(AdminUser.last))
        expect(find('.flash-notice')).to have_content(I18n.t('admin.messages.create.success'))
        expect(AdminUser.last.valid_password?('hogefuga')).to be_truthy
      end

      it '入力内容に不備があるとエラーメッセージが表示される' do
        visit new_admin_admin_user_path
        within('.right_col .x_panel') do
          click_on '登録する'
        end
        expect(find('.title_left')).to have_content(I18n.t('admin.actions.new'))
        expect(find('.flash-alert')).to have_content(I18n.t('admin.messages.create.failure'))
      end
    end
  end

  describe '管理者アカウント編集画面' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    context '未ログイン' do
      it 'アクセスできない' do
        visit edit_admin_admin_user_path(admin_user)
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'ログイン済み' do
      before do
        sign_in admin_user
      end

      it '各項目を入力後「更新する」ボタンを押すと管理者アカウントが編集される' do
        visit edit_admin_admin_user_path(admin_user)
        within('.right_col') do
          expect(find('.title_left')).to have_content(I18n.t('admin.actions.edit'))
          within('.x_panel') do
            fill_in 'admin_user[name]', with: 'Other name'
            click_on '更新する'
          end
        end
        expect(current_path).to eq(admin_admin_user_path(admin_user))
        expect(find('.title_left')).to have_content('Other name')
        expect(find('.flash-notice')).to have_content(I18n.t('admin.messages.update.success'))
      end

      it '入力内容に不備があるとエラーメッセージが表示される' do
        visit edit_admin_admin_user_path(admin_user)
        within('.right_col .x_panel') do
          fill_in 'admin_user[name]', with: ''
          click_on '更新する'
        end
        expect(find('.title_left')).to have_content(I18n.t('admin.actions.edit'))
        expect(find('.flash-alert')).to have_content(I18n.t('admin.messages.update.failure'))
      end
    end
  end

  describe 'パスワード変更画面' do
    let!(:admin_user) { FactoryBot.create(:admin_user) }

    context '未ログイン' do
      it 'アクセスできない' do
        visit password_admin_admin_users_path
        expect(current_path).to eq(new_admin_user_session_path)
      end
    end

    context 'ログイン済み' do
      before do
        sign_in admin_user
      end

      it '各項目を入力後「更新する」ボタンを押すとパスワードが変更される' do
        visit password_admin_admin_users_path
        within('.right_col') do
          expect(find('.title_left')).to have_content(I18n.t('admin.header.password'))
          within('.x_panel') do
            fill_in 'admin_user[password]', with: 'hogefuga123'
            fill_in 'admin_user[password_confirmation]', with: 'hogefuga123'
            click_on '更新する'
          end
        end
        expect(current_path).to eq(admin_admin_user_path(admin_user))
        expect(find('.title_left')).to have_content(admin_user.name)
        expect(find('.flash-notice')).to have_content(I18n.t('admin.messages.update.success'))
      end

      it '入力内容に不備があるとエラーメッセージが表示される' do
        visit password_admin_admin_users_path(admin_user)
        within('.right_col .x_panel') do
          click_on '更新する'
        end
        expect(find('.title_left')).to have_content(I18n.t('admin.header.password'))
        expect(find('.flash-alert')).to have_content(I18n.t('admin.messages.update.failure'))
      end
    end
  end
end
