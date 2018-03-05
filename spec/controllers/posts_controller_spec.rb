require 'rails_helper'

RSpec.describe PostsController, type: :controller do

  let(:user) do
    User.create(
      name: "Daniel",
      email: "email@example.com"
    )
  end
  let(:admin) do
    Admin.create(
      email: "admin@example.com",
      password: "123123123"
    )
  end

  before { sign_in admin }

  describe 'GET #index' do
    it 'should return an empty array when no posts are created' do
      get :index, params: { user_id: user.id }
      expect(assigns(:user)).to eq user
      expect(assigns(:posts)).to be_empty
    end

    it 'should return an array with 1 element when 1 post is created' do
      post = user.posts.create(
        title: "Example"
      )
      get :index, params: { user_id: user.id }
      expect(assigns(:user)).to eq user
      expect(assigns(:posts).size).to eq 1
    end
  end

  describe 'GET #show' do
    it 'should return the correct post' do
      post = user.posts.create(
        title: "Example"
      )
      get :show, params: { user_id: user.id, id: post.id }
      expect(assigns(:post)).to eq post
    end
  end

  describe 'GET #new' do
    it 'should return a new instance of a post' do
      get :new, params: { user_id: user.id }
      expect(assigns(:user)).to eq user
      expect(assigns(:post)).to be_a_new(Post).with(user_id: user.id)
    end
  end

  describe 'POST #create' do
    context 'when post save is successful' do
      it 'should save with the correct attributes' do
        post :create, params: { user_id: user.id, post: { title: 'My Title' } }
        expect(assigns(:post)).to be_a(Post)
        expect(assigns(:post)).to have_attributes(title: 'My Title')
      end

      it 'redirects and set flash' do
        post :create, params: { user_id: user.id, post: { title: 'My Title' } }
        expect(response).to redirect_to user_post_path(user, Post.last)
        expect(flash[:notice]).to eq 'Post was successfully created.'
      end
    end

    context 'when post save is unsuccessful' do
      it 'should not be saved' do
        post :create, params: { user_id: user.id, post: { title: '' } }
        expect(assigns(:post)).to be_a_new(Post).with(title: '')
      end

      it 'should render a form' do
        post :create, params: { user_id: user.id, post: { title: '' } }
        expect(response).to render_template(:new)
      end
    end
  end

end
