insert into public.navhistory select * from public.nav;
commit;
truncate public.nav;

