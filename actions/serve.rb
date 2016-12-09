#!/bin/env ruby
# encoding: utf-8

class ActionServe

  include Action

  def initialize q = nil

    super

    @name = "Serve"
    @docs = "Deliver the Paradise API."

  end

  def act q = nil
    
    vessel_handle, action_handle, params_handle = parse_query(q)
    
    return "vessel(#{vessel_handle}) action(#{action_handle}) params(#{params_handle})"

  end
  
  def parse_query q
    
    parts = q.to_s.split(" ")
    if parts.length < 3 then return "Missing query elements." end
    
    return parts[0].strip, parts[1].strip, q.sub(parts[0],'').sub(parts[1],'').strip
    
  end

end