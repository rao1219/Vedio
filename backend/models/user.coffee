module.exports = (sequelize, DataTypes) ->

  User = sequelize.define 'User', {
    username:
      type: DataTypes.STRING
      allowNull: false
      unique: true
      validate:
        notEmpty: true
        isAlphanumeric: true
    password:
      type: DataTypes.STRING
      allowNull: false
      validate:
        notEmpty: true
    role:
      type: DataTypes.ENUM('admin', 'reviewer', 'uploader', 'viewer')
      allowNull: false
  }, {
    indexes: [
      {
        unique: true
        fields: ['username']
      }
    ]
  }
