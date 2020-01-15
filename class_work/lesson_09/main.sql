
set statistics io on

set statistics time on



select * from user_details where username like ('%mike%') --- до индекса
go


create index ix_user_det_username
on user_details
(username)
;
go

drop index ix_user_det_username
on user_details
;
go


create index ix_user_det_username
on user_details
(username)include(first_name)
;
go



