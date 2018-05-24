SparkleFormation.dynamic(:elb) do |name, opts={}|
  instance_list = []
  state!(:frontend_count).to_i.times do |i|
    instance_list << ref!("#{state!(:instance_name)}#{i}_ec2_instance".to_sym)
  end

  dynamic!(:elastic_load_balancing_load_balancer, name.gsub('_','')) do
    properties do
      load_balancer_name "#{name.gsub('_','')}-lb".to_sym
      subnets [ ref!(:network_subnet_id1), ref!(:network_subnet_id2) ]
      listeners array!(
        -> {
         load_balancer_port "80"
         instance_port "80"
         protocol "http"
        }
      )
      instances instance_list
    end
  end
end
