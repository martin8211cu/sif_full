declare @check1 int, @check2 int, @check3 int, @check4 int,
@plaza int, @cedula varchar(12), @puesto varchar(12), @centro_funcional varchar(12), @id numeric

/* revisa si la accion ya fue cargada*/
select 
         @check1 = count(1) 
from  
         #table_name# a, DatosEmpleado b, RHAcciones c, 
         RHTipoAccion d
where 
        a.cedula = b.DEidentificacion and
        b.DEid = c.DEid and
        a.tipo_accion  = d.RHTcodigo and
        c.RHTid = d.RHTid and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin  and
        c.Ecodigo  = @Ecodigo

/*revisa si hay Tipos de accion no validos */
select 
         @check2 = count(1) 
from  
         #table_name# a
where 
        not exists (select 1 from RHTipoAccion b
			where a.tipo_accion  = b.RHTcodigo
			and   b.Ecodigo  = @Ecodigo
		)

/*revisa si hay Plazas que no existen*/
select 
         @check3 = count(1) 
from  
         #table_name# a
where 
        not exists (select 1 from RHPlazas b
			where a.plaza   = b.RHPcodigo
			and   b.Ecodigo  = @Ecodigo
		)

/*revisa si hay Puestos que no existen*/
select 
         @check4 = count(1) 
from  
         #table_name# a
where 
        not exists (select 1 from RHPuestos b
			where a.puesto = b.RHPcodigo
			and   b.Ecodigo  = @Ecodigo
		)

if (@check1 < 1 and  @check2 < 1  and  @check3 < 1  and  @check4 < 1)
begin

	update #table_name#
	set departamento = c.Dcodigo,
                oficina = Ocodigo
	from CFuncional c
	where c.Ecodigo = @Ecodigo
	and   c.CFcodigo = centro_costo

	if exists (select 1 from ComponentesSalariales where CSusatabla = 1 and CSsalariobase = 1)
	begin
		insert RHAcciones 
		(DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
		Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
		DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
		RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
		RHAvcomp, IEid ,TEid )
		select   DEid, RHTid, @Ecodigo, nomina, RVid, RHJid, e.RHTCid, 
		departamento, oficina, RHPid, puesto, desde, hasta, 
		convert(money, a.salario), descripcion, @Usucodigo, '00', 
		porc_plaza, porc_salario, null, disfrutados, compensados,
		null, null
		from    #table_name# a, RegimenVacaciones b, RHJornadas c, 
			RHPlazas d, RHCategoriasTipoTabla e, 
			RHTTablaSalarial f, RHTipoAccion g, DatosEmpleado h
		where a.cedula = h.DEidentificacion
			and a.regimen = b.RVcodigo
			and h.Ecodigo = b.Ecodigo
			and a.jornada = c.RHJcodigo
			and h.Ecodigo = c.Ecodigo
			and a.plaza   = d.RHPcodigo
			and h.Ecodigo = d.Ecodigo
			and e.RHTTid  = f.RHTTid
			and h.Ecodigo = f.Ecodigo
			and e.RHMCcodigo  = a.categoria
			and e.RHMCpaso  = a.paso
			and a.tipo_accion  = g.RHTcodigo
			and h.Ecodigo = g.Ecodigo
			and h.Ecodigo  = @Ecodigo
	end 
	else
	begin

			insert RHAcciones 
			(DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
			Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
			DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
			RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
			RHAvcomp, IEid ,TEid ) 
			select DEid, RHTid, @Ecodigo, nomina, RVid, RHJid, null, 
			departamento, oficina, RHPid, puesto, desde, hasta, 
			convert(money, a.salario), descripcion, @Usucodigo, '00', 
			porc_plaza, porc_salario, null, disfrutados, compensados,
			null, null
			from #table_name#  a, 
				DatosEmpleado b, 
				RegimenVacaciones c, 
				RHJornadas d, 
				RHPlazas e,
				RHTipoAccion f
			where a.cedula =  b.DEidentificacion
				and b.Ecodigo  = @Ecodigo
				and a.regimen = c.RVcodigo
				and b.Ecodigo = c.Ecodigo
				and a.jornada = d.RHJcodigo
				and b.Ecodigo = d.Ecodigo
				and a.plaza   = e.RHPcodigo
				and b.Ecodigo = e.Ecodigo
				and a.tipo_accion = f.RHTcodigo
				and b.Ecodigo = f.Ecodigo
	end
end
else 
begin
	if (@check1 >= 1) 
	begin
		select 'Datos ya existen', c.DEid,  c.RHTid, DLfvigencia, DLffin , c.Ecodigo 
		from #table_name# a, DatosEmpleado b, RHAcciones c, RHTipoAccion d
		where a.cedula = b.DEidentificacion
		and 	b.DEid = c.DEid
		and   a.tipo_accion  = d.RHTcodigo
        and c.RHTid = d.RHTid
        and a.desde = c.DLfvigencia
        and a.hasta = c.DLffin
        and c.Ecodigo  = @Ecodigo
	end

	if (@check2 >= 1) 
	begin
		/*revisa si hay Tipos de accion no validos */
		select 'Tipo de accion no existe', a.* 
		from  
			#table_name# a
		where 
	      not exists (select 1 from RHTipoAccion b
				where a.tipo_accion  = b.RHTcodigo
				and   b.Ecodigo  = @Ecodigo
				)
	end

	if (@check3 >= 1) 
	begin
		/*revisa si hay Plazas que no existen*/
		select 'Plaza no existe', a.* 
		from  
    	#table_name# a
		where 
			not exists (select 1 from RHPlazas b
			where a.plaza   = b.RHPcodigo
			and   b.Ecodigo  = @Ecodigo
		)
	end

	if (@check4 >= 1) 
	begin
		/*revisa si hay Puestos que no existen*/
		select 'Puesto no existe', a.* 
		from  
			#table_name# a
		where 
			not exists (select 1 from RHPuestos b
			where a.puesto = b.RHPcodigo
			and   b.Ecodigo  = @Ecodigo
			)
	end 
end