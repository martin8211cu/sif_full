declare @check1 numeric, @check2 numeric, @check3 numeric,  @mini numeric, @Ccodigoclaspadre  varchar(5),
 @Ccodigoclas varchar(5), @Ccodigopadre numeric,  @Cnivel numeric, @Cpath varchar(255), @maxid numeric

-- Validar que no existan duplicados en el archivo
select @check1 = count(count(1))
from #table_name#
group by Ccodigoclas
having count(1) > 1

if @check1 < 1 begin
 -- Validar si ya existe el codigo de clasificacion en el sistema
 select @check2 = count(1)
   from #table_name# a, Clasificaciones b
    where a.Ccodigoclas = b.Ccodigoclas
       and b.Ecodigo = @Ecodigo

 if @check2 < 1 begin
  --Validar que exista el codigo del padre
  select @check3 = count(1)  from #table_name# a 
    where ltrim(rtrim(a.Ccodigoclaspadre)) <> '' 
      and a.Ccodigoclaspadre  is not null
      and  not exists ( select 1 
                                  from #table_name# b
                                   where a.Ccodigoclaspadre = b.Ccodigoclas)

   if @check3 < 1 begin
    select @maxid = max(Ccodigo) from Clasificaciones where Ecodigo = @Ecodigo
    select @maxid = isnull(@maxid, 0) 
    select @mini = -1
    select @mini = min(id) from #table_name# where id > @mini
    while @mini is not null begin
      select @Ccodigoclaspadre = ltrim(rtrim(Ccodigoclaspadre)) , 
               @Ccodigoclas = ltrim(rtrim(Ccodigoclas))
         from #table_name# where id = @mini
      if (@Ccodigoclaspadre = '') or (@Ccodigoclaspadre is null) begin
       select @Cnivel = 0, @Cpath = right(('00000' + @Ccodigoclas), 5)
        select @Ccodigopadre = null     
      end
      else begin
        select @Cnivel = 0
        select @Cpath = right(('00000' + @Ccodigoclas), 5) 
        select @Ccodigopadre = a.id from #table_name# a
           where a.Ccodigoclas = @Ccodigoclaspadre
        select @Ccodigopadre = isnull(@Ccodigopadre, 0) + @maxid
        while (@Ccodigoclaspadre is not null) and (@Ccodigoclaspadre <>'') begin
          select @Cpath = right(('00000' + @Ccodigoclaspadre), 5)  +  '/' +  @Cpath 
          select @Cnivel = @Cnivel + 1
          select @Ccodigoclaspadre = ltrim(rtrim(Ccodigoclaspadre)) from #table_name#
             where Ccodigoclas = @Ccodigoclaspadre
        end 
      end
             
            insert Clasificaciones(Ecodigo, Ccodigo, Ccodigopadre, Ccodigoclas, Cdescripcion, Cpath, Cnivel, Ccomision, cuentac)
                        select @Ecodigo, id + @maxid, @Ccodigopadre, Ccodigoclas, Cdescripcion, @Cpath, @Cnivel, Ccomision, cuentac
                 from #table_name# a
                 where a.id = @mini

      select @mini = min(id) from #table_name# where id > @mini
    end
   end
   else begin
      select 'No existe el codigo del padre' as Error, a.Ccodigoclaspadre as Codigo_Padre
      from #table_name# a 
       where ltrim(rtrim(a.Ccodigoclaspadre)) <> '' 
          and a.Ccodigoclaspadre is not null
          and  not exists (select 1 from #table_name# b
                                  where b.Ccodigoclas = a.Ccodigoclaspadre)
   end --check3
 end
 else begin
   select 'Codigo de Clasificacion ya existe en el sistema' as Error, a.Ccodigoclas as Clasificacion
    from #table_name# a, Clasificaciones b
    where a.Ccodigoclas = b.Ccodigoclas
       and b.Ecodigo = @Ecodigo
 end --check2
end
else begin
 select 'Codigo de Clasificacion aparece duplicado en el archivo' as Error, Ccodigoclas as Clasificacion
   from #table_name#
  group by Ccodigoclas
  having count(1) > 1
end --check1
