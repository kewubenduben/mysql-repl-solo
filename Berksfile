source "https://api.berkshelf.com"

cookbook 'apt'
cookbook 'mysql', github: 'kewubenduben/mysql'

group :integration do
  cookbook 'chris-mysql', path: 'site-cookbooks/chris-mysql'
end
