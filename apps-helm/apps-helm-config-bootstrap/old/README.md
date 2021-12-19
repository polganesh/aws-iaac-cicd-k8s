Please execute following commands from same directory
These are required for creating Application load balancer and registering it with Nginx.

# install nginx ingress
```
helm upgrade --install nginx nginx-ingress -f values-nginx.yaml
```

# Install ALB helm chart
```
helm upgrade --install --namespace ingress alb aws-alb-ingress-controller --set-string autoDiscoverAwsRegion=true --set-string autoDiscoverAwsVpcID=true --set clusterName=<cluster-name> --set extraEnv.AWS_ACCESS_KEY_ID=<access-key> --set extraEnv.AWS_SECRET_ACCESS_KEY=<secret-access-key>


```

# Install mapper for alb and nginx
This will 
- create actual Application load balancer in AWS.
  - for more information refer - alb.ingress.kubernetes.io/subnets - subnets where alb needs to be created. these are our public subnets
- register certificate with load balancer (if it is needed)
  - for more information refer - alb.ingress.kubernetes.io/certificate-arn
- restict to specific CIDR
  - alb.ingress.kubernetes.io/inbound-cidrs
```
kubectl apply -f alb-nginx-mapper-ingress.yaml
```
