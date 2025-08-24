how to
#keys will be rotated
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""



cd Day1
source creds.sh
terraform init,fmt,plan,apply
