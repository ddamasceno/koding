class JMount extends jraphical.Capsule
  {Model,secure} = require 'bongo'
  
  @share()
  
  @set
    sharedMethods :
      instance    : ["save","update","remove"]
      static      : ["on"]

  save: secure (client,callback)->
    mount = @
    account = client.connection.delegate
    if account instanceof JGuest
      callback new Error "guest cant add mount"
    else
      Model::save.call @, (err)->
        if err
          callback err
        else
          account.addMount mount, callback

  update: secure (client,callback)->
    account = client.connection.delegate
    jraphical.Relationship.one
      sourceId: account.getId()
      targetId: @getId()
      as: 'owner'
    , (err, ownership)=>
      if err
        callback err
      else
        unless ownership
          callback new Error "Access denied!"
        else
          Model::update.call @, callback
      

class JMountFTP extends JMount
  {secure} = require 'bongo'
  
  @share()
  
  @set
    encapsulatedBy  : JMount
    sharedMethods   : JMount.sharedMethods
    schema          :
      title         : { type  : String,  default   : -> @hostname }
      hostname      : { type  : String,  required  : yes }
      username      : { type  : String,  required  : yes }
      password      : { type  : String,  required  : yes }
      port          : { type  : Number,  default   : 21  } 
      initialPath   : String

#  save: secure (client,callback)->
#    #check if ftp is legit then call uber.
#    @uber "save", client, callback
#  
class JMountSFTP extends JMount

  @share()

  @set
    encapsulatedBy  : JMount
    sharedMethods   : JMount.sharedMethods
    schema          :
      title         : { type  : String,  default   : -> @hostname }
      hostname      : { type  : String,  required  : yes }
      username      : { type  : String,  required  : yes }
      password      : { type  : String,  required  : yes }
      port          : { type  : Number,  default   : 22  } 
      initialPath   : String
  
class JMountS3 extends JMount
  
  @share()

  @set
    encapsulatedBy  : JMount
    sharedMethods   : JMount.sharedMethods
    schema          :
      title         : { type  : String,  default   : -> @hostname }
      accessKeyId   : { type  : String,  required  : yes }
      secret        : { type  : String,  required  : yes }
      initialPath   : String


class JMountWebDAV extends JMount

  @share()

  @set
    encapsulatedBy  : JMount
    sharedMethods   : JMount.sharedMethods
    schema          :
      title         : { type  : String,  default   : -> @hostname }
      hostname      : { type  : String,  required  : yes }
      username      : { type  : String,  required  : yes }
      password      : { type  : String,  required  : yes }
      port          : { type  : Number,  default   : 21  } 
      initialPath   : String

