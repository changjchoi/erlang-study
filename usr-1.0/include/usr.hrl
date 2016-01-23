%%% File : usr.hrl
%%% Description : Include File for user DB

-record(usr, {msisdn,           % int()
              id,               % term()
              status = enabled, % atom(), enabled | disabled
              plan,             % atom(), prepay | postpay
              services = []}).   % [atom()], service flag list

