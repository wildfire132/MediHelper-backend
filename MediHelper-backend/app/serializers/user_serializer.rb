class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :email, :img_url, :token
end
