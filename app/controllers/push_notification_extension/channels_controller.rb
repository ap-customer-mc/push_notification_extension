require_dependency "push_notification_extension/application_controller"

module PushNotificationExtension
  class ChannelsController < ApplicationController
    before_filter :authenticate_admin!
    
    def edit
      @channel = ::PushNotificationExtension::Channel.find(params[:id])
      @devices = @channel.devices.order_by([:type])
      @available_devices = ::PushNotificationExtension::Device.all.not_in(id: @devices.map {|d| d.id })
    end
    
    def update
      @channel = ::PushNotificationExtension::Channel.find(params[:id])
      devices_to_add = params[:device_ids]
      devices_to_add.each do |device|
        @channel.devices << ::PushNotificationExtension::Device.find(device)
      end
      
      @devices = @channel.devices.order_by([:type])
      @available_devices = ::PushNotificationExtension::Device.all.not_in(id: @devices.map {|d| d.id })
      respond_to do |format|
        format.html { render action: "edit" }
      end
    end
    
    def push
      @channel = ::PushNotificationExtension::Channel.find(params[:id])
    end
    
    def manual_push
      debugger
      @channel = ::PushNotificationExtension::Channel.find(params[:id])
      @channel.publish(params[:badge], params[:alert], params[:message])
      
      respond_to do |format|
        format.html { redirect_to settings_path }
      end
    end
    
  end
end
