/* tomado de desarrollo.dbo.minisif el 6-jun-2006 como base para RH_CalculoNomina.cfc */

create procedure rh_CalculoNomina
    @Ecodigo int,
    @RCNid numeric,
    @Tcodigo char(5),
    @RCdesde datetime,
    @RChasta datetime,
    @IRcodigo char(5),
    @Usucodigo numeric,
    @Ulocalizacion char(2) = '00',
    @debug char(1) = 'N',
    @pDEid numeric = null
as
/*
** Calcula la nómina para uno o todos los empleados
** Hecho por: Marcel de Mézerville L.
** Fecha: 09 Junio 2003
*/
declare 
	@CantPagosRealizados int,
	@CantPagosPeriodo    int,
	@per int,
	@mes int,
	@Factor float,
	@CantDiasMensual int,
	@cantdias int,
	@retroactivo int,
	@idincidenciared numeric,
	@factored money,
	@tipored int,
	@minimo money,
	@CSid numeric,     -- Id del componente del salario base
	@frecuencia int,
    @PagoComision int,
	@error int,
	@CPnorenta int,
	@CPnocargas int,
	@CPnocargasley int,
	@CPtipo int,
    @CPidant numeric

select 
	@CPnorenta = CPnorenta,
	@CPnocargas = CPnocargas,
	@CPnocargasley = CPnocargasley,
	@CPtipo = @CPtipo
from CalendarioPagos
where CPid = @RCNid
    
select @retroactivo = 0, @error = 0

-- Obtener los parametros iniciales para el proceso
if @Tcodigo is null begin
	select 
		@RCdesde = RCdesde, @RChasta = RChasta, @Tcodigo = Tcodigo
	from RCalculoNomina
	where RCNid = @RCNid
end

select @frecuencia = b.Ttipopago
from RCalculoNomina a, TiposNomina b
where a.RCNid = @RCNid
   and b.Ecodigo = a.Ecodigo
   and b.Tcodigo = a.Tcodigo
   
select @IRcodigo = Pvalor
from RHParametros
where Ecodigo = @Ecodigo
and Pcodigo = 30
    
if @IRcodigo is null begin
	raiserror 40000 'Error!, No se ha definido la Tabla de Impuesto de Renta a utilizar en los parámetros del Sistema. Proceso Cancelado!!'
	return -1
end

/* 	Obtener factor de redondeo y id de la incidencia para redondeo */
select @factored = convert(money,Pvalor)
from RHParametros
where Ecodigo = @Ecodigo
  and Pcodigo = 110
  
select @factored = isnull(@factored,0.00)

select @tipored = convert(int,Pvalor)
from RHParametros
where Ecodigo = @Ecodigo
  and Pcodigo = 120

select @tipored = isnull(@tipored,1)
  
select @idincidenciared = CIid
from CIncidentes 
where Ecodigo = @Ecodigo
  and CIredondeo = 1
  
if (@idincidenciared is null) begin
	select @idincidenciared = CIid
	from CIncidentes 
	where Ecodigo = @Ecodigo
	  and CIid = (
		select min(b.CIid)
		from CIncidentes b
		where b.Ecodigo = @Ecodigo
	)
end

if (@idincidenciared is null) 
begin
	RAISERROR 40000 "Error, no se ha definido el Concepto de Pago para Redondeo!. Proceso Cancelado."
	RETURN -1
end

/*
	Periodo (ANIO) y mes del Calendario de Pagos de la Nomina en Proceso. 
	De aqui se obtiene luego el factor de calculo para "suavizar" el cobro del 
	impuesto de renta, aplicando anticipos de retencion
*/
select @per = CPperiodo, @mes = CPmes
from CalendarioPagos
where CPid = @RCNid
    
if (@per is null or @mes is null)
begin
	raiserror 40000 'Error, No se pudo obtener el ID en el Calendario de Pagos correspondiente a las fehas de la relación de Cálculo de Nómina!!!!. Proceso Cancelado.'
	return -1
end

if @CPnorenta = 0 begin    
    select 
    	@CantPagosPeriodo = (
    		select count(1) 
    		from CalendarioPagos 
    		where Ecodigo = @Ecodigo
    		  and Tcodigo = @Tcodigo
    		  and CPperiodo = @per
    		  and CPmes = @mes
              and CPtipo = 0),
    	@CantPagosRealizados = (
    		select count(1) 
    		from CalendarioPagos 
    		where Ecodigo = @Ecodigo
    		  and Tcodigo = @Tcodigo
    		  and CPperiodo = @per
    		  and CPmes = @mes
    		  and CPtipo = 0
              and CPdesde <= @RCdesde)

    if (@CantPagosRealizados = 0.00) begin
    	raiserror 40000 'Error, No se puede obtener el factor para el cálculo del salario proyectado!.Proceso Cancelado.'
    	return -1
    end 
    
    select @Factor = convert(float, @CantPagosPeriodo) / convert(float, @CantPagosRealizados)
end

if @Factor = 0.00 begin
	raiserror 40000 'Error, El factor obtenido para el cálculo del salario proyectado es Cero!.Proceso Cancelado.'
	return -1
end


/* Definir el componente de salario base del empleado */
select @CSid = min(CSid) 
from ComponentesSalariales
where Ecodigo = @Ecodigo
  and CSsalariobase = 1

if @CSid is null
	select @CSid = cs.CSid
	from ComponentesSalariales cs
	where cs.Ecodigo = @Ecodigo
	  and cs.CScodigo = (select min(cs2.CScodigo) from ComponentesSalariales cs2 where cs2.Ecodigo = @Ecodigo)

/* Fin de definicion del componente de salario base del empleado */

/* 	La variable @CantDiasMensual contiene el valor del parametro
	asignado a la cantidad de dias que se trabajan en el "mes"
	definido por la empresa
	La variable @cantdias identifica la cantidad de dias que se estan 
	pagando en esta nomina (diferencia de dias calendario).
	A este valor se le restan luego los dias no laborables asignados
	al tipo de nomina. 
*/

select
	@CantDiasMensual = convert(int,Pvalor), 
	@cantdias = abs(datediff(dd, @RChasta, @RCdesde)) + 1
from RHParametros
where Ecodigo = @Ecodigo
  and Pcodigo = 80
      
IF @CantDiasMensual is null BEGIN
	RAISERROR 40000 "Error, no se ha definido la cantidad de días a utilizar para el cálculo de la nómina mensual en los parámetros del Sistema. Proceso Cancelado."
	RETURN -1
END

select @cantdias = @cantdias - ((
		select  count(1)
		from DiasTiposNomina 
		where Ecodigo = @Ecodigo 
		and Tcodigo = @Tcodigo) 
	* floor(@cantdias / 7))

if @frecuencia = 2 begin
 select @cantdias = @CantDiasMensual / 2
end
 
if @frecuencia = 3 begin
 select @cantdias = @CantDiasMensual
end

/* 	El valor que contiene la variable @minimo 
	equivale al salario minimo legal por mes
	Se utiliza como parametro para calculo de deducciones de ley
	que valoran la deduccion contra el salario minimo de ley mensual
*/

select @minimo = convert(money, pn.Pvalor) / @CantDiasMensual * @cantdias
from RCalculoNomina rn, RHParametros pn
where rn.RCNid = @RCNid
  and pn.Ecodigo = rn.Ecodigo
  and pn.Pcodigo = 130

begin
	/* 
		Borrar incidencias del tipo del codigo de incidencia de redondeo 
		siempre y cuando no existan en la tabla de incidencias capturadas 
	*/
        if @pDEid is null begin
          delete IncidenciasCalculo
          where RCNid = @RCNid
            and CIid = @idincidenciared
            and not exists (
           select 1 
           from Incidencias b
           where b.DEid = IncidenciasCalculo.DEid
             and b.CIid = IncidenciasCalculo.CIid
             and b.Ifecha = IncidenciasCalculo.ICfecha)
         end else begin
          delete IncidenciasCalculo
          where RCNid = @RCNid
            and DEid = @pDEid
            and CIid = @idincidenciared
            and not exists (
           select 1 
           from Incidencias b
           where b.DEid = IncidenciasCalculo.DEid
             and b.CIid = IncidenciasCalculo.CIid
             and b.Ifecha = IncidenciasCalculo.ICfecha)
         end


    /* Actualizar el monto de salario en cero cuando la jornada es por hora */
     update PagosEmpleado
     set PEmontores = 0
     from PagosEmpleado pe, RHJornadas j
     where pe.RCNid = @RCNid
       and (@pDEid is null or pe.DEid = @pDEid)
       and j.RHJid = pe.RHJid
       and j.RHJornadahora = 1

	/* 
		Calculo del Monto de las Incidencias (Pagos Variables) 
		Condiciones:

			1. IncidenciasCalculo de esta relacion de calculo (RCNid = @RCNid)
			2. Fecha de Incidencia debe ser menor que la fecha hasta de la relacion de pago (ICfecha <= @RChasta)
			3. Empleado no calculado (SalarioEmpleado.SEcalculado = 0)
			4. Tipo de Incidencia debe ser por hora o por dia (CItipo < 2 donde CItipo = 0 --> Horas, CItipo = 1 --> Dias)

		Calculo:
			1. Salario por Hora o por Dia es:
				componente de Salario Base del Detalle de la Linea del tiempo / horas de la jornada * CIfactor * CInegativo (subquery)

	*/
     update IncidenciasCalculo
      set ICmontores = 
		((select
			case 
				when (b.CItipo = 0 and coalesce(j.RHJhorasemanal, 0.00) > 1.00)
					then 
			        	coalesce(
						round(
								coalesce((
									select coalesce(dt.DLTmonto, 0.00) 
									from DLineaTiempo dt, ComponentesSalariales cs
									where dt.LTid = lt.LTid
									  and dt.CSid = @CSid
                                      and cs.CSid = dt.CSid
                                      and cs.CSpagohora = 1
								), 0.00)
								* 12.0 / 52.0 
								* ic.ICvalor 
								* b.CIfactor 
								* b.CInegativo 
								/ (j.RHJhorasemanal * 1.00)
						,2), 0.00)

				when (b.CItipo = 0 and coalesce(j.RHJhoradiaria, 0.00) > 1.00)
					then 
			        	coalesce(
						round(
								coalesce((
									select coalesce(dt.DLTmonto, 0.00) 
									from DLineaTiempo dt, ComponentesSalariales cs
									where dt.LTid = lt.LTid
									  and dt.CSid = @CSid
                                      and cs.CSid = dt.CSid
                                      and cs.CSpagohora = 1
								), 0.00)
								/ @CantDiasMensual 
								* ic.ICvalor 
								* b.CIfactor 
								* b.CInegativo 
								/ (j.RHJhoradiaria * 1.00)
						,2), 0.00)

				when (b.CItipo = 1 and coalesce (j.RHJdiassemanal, 0) >  1.00)
					then
			        	coalesce(
						round(
								coalesce(( 
									select coalesce(dt.DLTmonto, 0.00) 
									from DLineaTiempo dt, ComponentesSalariales cs
									where dt.LTid = lt.LTid
									  and dt.CSid = @CSid
                                      and cs.CSid = dt.CSid
                                      and cs.CSpagodia = 1
                                      
								), 0.00)
								* 12.0 / 52.0 
								* ic.ICvalor 
								* b.CIfactor 
								* b.CInegativo 
								/ (j.RHJdiassemanal * 1.00)
						,2), 0.00)

				when (b.CItipo = 1)
					then
			        	coalesce(
						round(
								coalesce((
									select coalesce(dt.DLTmonto, 0.00) 
									from DLineaTiempo dt, ComponentesSalariales cs
									where dt.LTid = lt.LTid
									  and dt.CSid = @CSid
                                      and cs.CSid = dt.CSid
                                      and cs.CSpagodia = 1
								), 0.00)
								/ @CantDiasMensual  
								* ic.ICvalor 
								* b.CIfactor 
								* b.CInegativo 
						,2), 0.00)
				else
						0.00
   	    	end))
     from IncidenciasCalculo ic, SalarioEmpleado d, CIncidentes b, LineaTiempo lt, RHJornadas j
     where ic.RCNid = @RCNid   
       and ic.ICfecha <= @RChasta
       and d.DEid = ic.DEid
       and d.RCNid = ic.RCNid
       and (@pDEid is null or d.DEid = @pDEid)
       and d.SEcalculado = 0
       and b.CIid = ic.CIid
       and b.CItipo < 2                         -- Que no sea importe
       and ic.DEid = lt.DEid
       and ic.ICfecha between lt.LTdesde and lt.LThasta
       and j.RHJid = lt.RHJid

	if @@error !=0 begin
		raiserror 40000 'Error! No se pudo actualizar el monto de las Incidencias!. Proceso Cancelado!!!'
		return -1
	end


    /* Ejecutar el calculo de incidencias de comisiones cuando aplica */
     select @PagoComision = convert(int, isnull(Pvalor,'0'))
     from RHParametros
     where Ecodigo = @Ecodigo
       and Pcodigo = 330
 
     if @PagoComision = 1 
     begin
          exec rh_CalculoNominaComision 
              @Ecodigo = @Ecodigo,
              @RCNid = @RCNid,
              @Tcodigo = @Tcodigo,
              @RCdesde = @RCdesde,
              @RChasta = @RChasta,
              @IRcodigo = @IRcodigo,
              @Usucodigo = @Usucodigo,
              @Ulocalizacion = @Ulocalizacion,
              @debug = @debug,
              @pDEid = @pDEid
 
      if @@error !=0 begin
        raiserror 40000 'Error! No se pudo actualizar el monto de las Incidencias por Comisión!. Proceso Cancelado!!!'
        return -1
      end
     end

	update IncidenciasCalculo
		set ICmontores = round(IncidenciasCalculo.ICvalor,2) * b.CInegativo
	from CIncidentes b, SalarioEmpleado d
	where IncidenciasCalculo.RCNid = @RCNid   
	  and IncidenciasCalculo.ICfecha <= @RChasta
	  and b.CIid = IncidenciasCalculo.CIid
	  and b.CItipo > 1                         -- Que sea importe o calculo especial
	  and IncidenciasCalculo.DEid = d.DEid
	  and IncidenciasCalculo.RCNid = d.RCNid 
	  and d.SEcalculado = 0
	  and (@pDEid is null or d.DEid = @pDEid)

	if @@error !=0 begin
		raiserror 40000 'Error! No se pudo actualizar el monto de las Incidencias!. Proceso Cancelado!!!'
		return -1
	end
  
	update IncidenciasCalculo
		set ICmontores = round(IncidenciasCalculo.ICmontores - isnull(IncidenciasCalculo.ICmontoant, 0.00),2)
	from SalarioEmpleado d
	where IncidenciasCalculo.RCNid = @RCNid   
	  and IncidenciasCalculo.DEid = d.DEid
	  and IncidenciasCalculo.RCNid = d.RCNid 
	  and d.SEcalculado = 0
	  and (@pDEid is null or d.DEid = @pDEid)

	if @@error !=0 begin
		raiserror 40000 'Error! No se pudo actualizar el monto de las Incidencias!. Proceso Cancelado!!!'
		return -1
	end
	
    -- ACTUALIZA LOS MONTOS x EMPLEADO. Resumen de Nomina en la tabla SalarioEmpleado
	update SalarioEmpleado set 
		SEincidencias = isnull((select isnull(sum(b.ICmontores),0.00) from IncidenciasCalculo b where c.DEid = b.DEid and c.RCNid = b.RCNid), 0.00),
		SEsalariobruto = isnull((select isnull(sum(b.PEmontores) ,0.00) from PagosEmpleado b where c.DEid = b.DEid and c.RCNid = b.RCNid), 0.00)
	from SalarioEmpleado c
	where c.RCNid = @RCNid
	  and c.SEcalculado = 0
	  and (@pDEid is null or c.DEid = @pDEid)

	if @@error !=0 begin
		raiserror 40000 'Error! No se pudo actualizar el monto el Salario Bruto y el monto de las Incidencias por Empleado!. Proceso Cancelado!!!'
		return -1
	end

	/* Redondeo de Calculos */
	update SalarioEmpleado set 
		SEsalariobruto = round(SEsalariobruto,2),
		SEincidencias = round(SEincidencias,2),
		SErenta = round(SErenta,2),
		SEcargasempleado = round(SEcargasempleado,2),
		SEcargaspatrono = round(SEcargaspatrono,2),
		SEdeducciones = round(SEdeducciones,2)
	where RCNid = @RCNid
	  and SEcalculado = 0
	  and (@pDEid is null or DEid = @pDEid)

	-- Ingresos de salario que no se consideran para cálculos en esta nómina
	update SalarioEmpleado 
	set 
		SEinocargas = isnull((
			select sum(b.ICmontores)
			from IncidenciasCalculo b, CIncidentes d
			where c.DEid = b.DEid
			  and c.RCNid = b.RCNid
			  and d.CIid = b.CIid
			  and d.CInocargas > 0
		),0.00) + isnull((
			select sum(p.PEmontores)
			from PagosEmpleado p, RHTipoAccion t
			where p.DEid = c.DEid
			  and p.RCNid = c.RCNid
			  and t.RHTid = p.RHTid
			  and t.RHTnocargas > 0
		),0.00),
        SEinocargasley = isnull((
           select sum(b.ICmontores)
           from IncidenciasCalculo b, CIncidentes d
           where c.DEid = b.DEid
             and c.RCNid = b.RCNid
             and d.CIid = b.CIid
             and d.CInocargasley > 0
          ),0.00) + isnull((
           select sum(p.PEmontores)
           from PagosEmpleado p, RHTipoAccion t
           where p.DEid = c.DEid
             and p.RCNid = c.RCNid
             and t.RHTid = p.RHTid
             and t.RHTnocargasley > 0
          ),0.00),
		SEinodeduc = isnull((
			select sum(b.ICmontores)
			from IncidenciasCalculo b, CIncidentes d
			where c.DEid = b.DEid
			  and c.RCNid = b.RCNid
			  and d.CIid = b.CIid
			  and d.CInodeducciones > 0
		),0.00) + isnull((
			select sum(p.PEmontores)
			from PagosEmpleado p, RHTipoAccion t
			where p.DEid = c.DEid
			  and p.RCNid = c.RCNid
			  and t.RHTid = p.RHTid
			  and t.RHTnodeducciones > 0
		),0.00)
	from SalarioEmpleado c
	where c.RCNid = @RCNid
	  and c.SEcalculado = 0
	  and (@pDEid is null or c.DEid = @pDEid)

	/* -- Calculo de las CARGAS LABORALES . Empleado y Empleador */
	if @CPnocargas = 0 or @CPnocargasley = 0 
begin 
        update CargasCalculo set
    		CCvaloremp = 
    			case 
    			when DCmetodo = 0 
    				then isnull(b.CEvaloremp, c.DCvaloremp) 
    			when DCmetodo = 1 and d.ECauto = 0
    				then round((a.SEsalariobruto + a.SEincidencias - a.SEinocargas) * ((isnull(b.CEvaloremp, c.DCvaloremp))/100), 2)
                when c.DCmetodo = 1 and d.ECauto = 1
                    then round((a.SEsalariobruto + a.SEincidencias - a.SEinocargasley) * ((isnull(b.CEvaloremp, c.DCvaloremp))/100), 2) 
    			end, 
    		CCvalorpat = 
    			case 
    			when DCmetodo = 0 
    				then isnull(b.CEvalorpat, c.DCvalorpat) 
    			when DCmetodo = 1 and d.ECauto = 0
    				then round((a.SEsalariobruto + a.SEincidencias - a.SEinocargas) * ((isnull(b.CEvalorpat, c.DCvalorpat))/100), 2) 
                when c.DCmetodo = 1 and d.ECauto = 1
                    then round((a.SEsalariobruto + a.SEincidencias - a.SEinocargasley) * ((isnull(b.CEvalorpat, c.DCvalorpat))/100), 2)    
    			end
    	from SalarioEmpleado a, CargasEmpleado b, DCargas c, ECargas d
    	where CargasCalculo.RCNid = @RCNid
      	  and a.RCNid = CargasCalculo.RCNid
    	  and a.DEid = CargasCalculo.DEid
    	  and a.SEcalculado < 1
    	  and (@pDEid is null or a.DEid = @pDEid)
    	  and b.DEid = CargasCalculo.DEid
    	  and b.DClinea = CargasCalculo.DClinea
    	  and b.CEdesde <= @RChasta
    	  and isnull(b.CEhasta,'61000101') >= @RCdesde
    	  and c.DClinea = b.DClinea
          and d.ECid = c.ECid
          and d.Ecodigo = c.Ecodigo     
   	 end 
	/* Cuando La carga tiene rangos maximos definidos, se debe recalcular cuando se excede el monto de la carga */
	if exists(
		select 1
		from CargasCalculo cc
			inner join SalarioEmpleado se
				 on se.RCNid        = cc.RCNid
				and se.DEid         = cc.DEid
				and se.SEcalculado  < 1
			inner join DCargas dc
				on dc.DClinea       = cc.DClinea
		where cc.RCNid = @RCNid
		  and dc.DCmetodo = 1
		  and dc.DCtiporango > 0
		) 
	begin
		/* 1. Actualizar CargasCalculo con la Base Proyectada */
		update CargasCalculo
		set CCBaseSalProyectado = (
				coalesce((
					select sum(se.SEsalariobruto +  se.SEincidencias -  se.SEinocargasley)
					from SalarioEmpleado se
					where se.RCNid = CargasCalculo.RCNid
					  and se.DEid  = CargasCalculo.DEid )
				, 0.00)
				+
				coalesce((
					select sum(hs.SEsalariobruto +  hs.SEincidencias)
					from CalendarioPagos cp, CalendarioPagos cp2, HSalarioEmpleado hs
					where 
						    cp.CPid       = CargasCalculo.RCNid
						and cp2.Ecodigo   = cp.Ecodigo
						and cp2.CPperiodo = cp.CPperiodo
						and cp2.CPmes     = cp.CPmes
						and cp2.Tcodigo   = cp.Tcodigo
						and hs.RCNid      = cp2.CPid
						and hs.DEid       = CargasCalculo.DEid)
				, 0.00)
				-
				coalesce((
					select sum(hi.ICmontores)
					from CalendarioPagos cp, CalendarioPagos cp2, HIncidenciasCalculo hi, CIncidentes ci
					where 
						    cp.CPid          = CargasCalculo.RCNid
						and cp2.Ecodigo      = cp.Ecodigo
						and cp2.CPperiodo    = cp.CPperiodo
						and cp2.CPmes        = cp.CPmes
						and cp2.Tcodigo      = cp.Tcodigo
						and hi.RCNid         = cp2.CPid
						and hi.DEid          = CargasCalculo.DEid
						and ci.CIid          = hi.CIid
						and ci.CInocargasley > 0)
				, 0.00)
				)
				* @Factor
		where RCNid = @RCNid
		  and exists(
			select 1
			from SalarioEmpleado se
				inner join DCargas dc
			  on dc.DClinea       = CargasCalculo.DClinea
			where se.RCNid        = CargasCalculo.RCNid
			  and se.DEid         = CargasCalculo.DEid
			  and se.SEcalculado  < 1
			  and dc.DCmetodo     = 1
			  and dc.DCtiporango  > 0
			) 
		/* Actualizar el monto del calculo */
		update CargasCalculo
			set 
    		CCvaloremp = 
                    round((
						select dc1.DCrangomax * coalesce(ce.CEvaloremp, dc1.DCvaloremp, 0.00) / 100
						from CargasEmpleado ce
							inner join DCargas dc1
								on dc1.DClinea = ce.DClinea
						where ce.DEid = CargasCalculo.DEid
						  and ce.DClinea = CargasCalculo.DClinea
					), 2), 
    		CCvalorpat = 
                    round((
						select dc1.DCrangomax * coalesce(ce.CEvalorpat, dc1.DCvalorpat, 0.00) / 100
						from CargasEmpleado ce
							inner join DCargas dc1
								on dc1.DClinea = ce.DClinea
						where ce.DEid = CargasCalculo.DEid
						  and ce.DClinea = CargasCalculo.DClinea
					), 2)
		where RCNid = @RCNid
		  and exists(
			select 1
			from SalarioEmpleado se
				inner join DCargas dc
					on dc.DClinea       = CargasCalculo.DClinea
			where se.RCNid        = CargasCalculo.RCNid
			  and se.DEid         = CargasCalculo.DEid
			  and se.SEcalculado  < 1
			  and dc.DCmetodo     = 1
			  and dc.DCtiporango  > 0
			  and dc.DCrangomax   < CargasCalculo.CCBaseSalProyectado
			) 
		update CargasCalculo
			set 
    		CCvaloremp = 
                    round((
						select dc1.DCrangomin * coalesce(ce.CEvaloremp, dc1.DCvaloremp, 0.00) / 100
						from CargasEmpleado ce
							inner join DCargas dc1
								on dc1.DClinea = ce.DClinea
						where ce.DEid = CargasCalculo.DEid
						  and ce.DClinea = CargasCalculo.DClinea
					), 2), 
    		CCvalorpat = 
                    round((
						select dc1.DCrangomin * coalesce(ce.CEvalorpat, dc1.DCvalorpat, 0.00) / 100
						from CargasEmpleado ce
							inner join DCargas dc1
								on dc1.DClinea = ce.DClinea
						where ce.DEid = CargasCalculo.DEid
						  and ce.DClinea = CargasCalculo.DClinea
					), 2)
		where RCNid = @RCNid
		  and exists(
			select 1
			from SalarioEmpleado se
				inner join DCargas dc
					on dc.DClinea       = CargasCalculo.DClinea
			where se.RCNid        = CargasCalculo.RCNid
			  and se.DEid         = CargasCalculo.DEid
			  and se.SEcalculado  < 1
			  and dc.DCmetodo     = 1
			  and dc.DCtiporango  > 0
			  and dc.DCrangomin   > CargasCalculo.CCBaseSalProyectado
			) 
		
		/* Restar lo que ya se rebajó en otras nominas */
		update CargasCalculo
			set 
				CCvaloremp = CCvaloremp - coalesce((
					select sum(hc.CCvaloremp)
					from CalendarioPagos cp, CalendarioPagos cp2, HCargasCalculo hc
					where 	cp.CPid          = CargasCalculo.RCNid
						and cp2.Ecodigo      = cp.Ecodigo
						and cp2.CPperiodo    = cp.CPperiodo
						and cp2.CPmes        = cp.CPmes
						and cp2.Tcodigo      = cp.Tcodigo
					    and hc.DEid          = CargasCalculo.DEid
					    and hc.RCNid         = cp2.CPid
					) , 0.00),
				CCvalorpat = CCvalorpat - coalesce((
					select sum(hc.CCvalorpat)
					from CalendarioPagos cp, CalendarioPagos cp2, HCargasCalculo hc
					where 	cp.CPid          = CargasCalculo.RCNid
						and cp2.Ecodigo      = cp.Ecodigo
						and cp2.CPperiodo    = cp.CPperiodo
						and cp2.CPmes        = cp.CPmes
						and cp2.Tcodigo      = cp.Tcodigo
					    and hc.DEid          = CargasCalculo.DEid
					    and hc.RCNid         = cp2.CPid
					) , 0.00)
		where RCNid = @RCNid
		  and exists(
			select 1
			from SalarioEmpleado se
				inner join DCargas dc
					on dc.DClinea       = CargasCalculo.DClinea
			where se.RCNid        = CargasCalculo.RCNid
			  and se.DEid         = CargasCalculo.DEid
			  and se.SEcalculado  < 1
			  and dc.DCmetodo     = 1
			  and dc.DCtiporango  > 0
			  and CargasCalculo.CCBaseSalProyectado not between dc.DCrangomin and dc.DCrangomax
			) 
		update CargasCalculo
			set 
				CCvaloremp = round(CCvaloremp / @Factor, 2),
				CCvalorpat = round(CCvalorpat / @Factor, 2)
		where RCNid = @RCNid
		  and exists(
			select 1
			from SalarioEmpleado se
				inner join DCargas dc
					on dc.DClinea       = CargasCalculo.DClinea
			where se.RCNid        = CargasCalculo.RCNid
			  and se.DEid         = CargasCalculo.DEid
			  and se.SEcalculado  < 1
			  and dc.DCmetodo     = 1
			  and dc.DCtiporango  > 0
			  and CargasCalculo.CCBaseSalProyectado not between dc.DCrangomin and dc.DCrangomax
			) 
	end
    	
    /* Deducciones */
    update DeduccionesCalculo 
    set 
      DCvalor = 
           coalesce((
                  select case when Dmetodo = 0 then round((round(c.SEsalariobruto + c.SEincidencias - c.SEinodeduc,2) * a.Dvalor/100),2) else a.Dvalor end
                  from SalarioEmpleado c, DeduccionesEmpleado a
                  where c.DEid = DeduccionesCalculo.DEid 
                     and c.RCNid = DeduccionesCalculo.RCNid
                     and a.Did = DeduccionesCalculo.Did
           ), 0.00),
      DCinteres = 0.00
    where DeduccionesCalculo.RCNid = @RCNid
       and (@pDEid is null or DeduccionesCalculo.DEid = @pDEid)
       and not exists(
             select 1 from DeduccionesEmpleadoPlan pp
             where pp.Did = DeduccionesCalculo.Did)
 
    update DeduccionesCalculo 
    set 
      DCvalor = 
            coalesce((select sum(pl.PPprincipal + pl.PPinteres)
                   from DeduccionesEmpleadoPlan pl
                   where pl.Did = DeduccionesCalculo.Did 
                      and pl.PPfecha_vence = @RChasta
                      and pl.PPfecha_pago is null
                      and pl.PPpagado != 1
              ), 0.00),
      DCinteres = 
           coalesce((select sum(pl.PPinteres)
                  from DeduccionesEmpleadoPlan pl
                  where pl.Did = DeduccionesCalculo.Did 
                     and pl.PPfecha_vence = @RChasta
                     and pl.PPfecha_pago is null
                     and pl.PPpagado != 1
              ), 0.00)
     where DeduccionesCalculo.RCNid = @RCNid
       and (@pDEid is null or DeduccionesCalculo.DEid = @pDEid)
       and exists(
             select 1 from DeduccionesEmpleadoPlan pp
             where pp.Did = DeduccionesCalculo.Did)
             
    if @CPnorenta = 0 begin
    	if isnull((select Pvalor from RHParametros where Ecodigo = @Ecodigo and Pcodigo = 250), '0') = '0' begin
    		exec rh_CalculoNominaRentaCR
    			@RCNid = @RCNid, 
    			@Ecodigo = @Ecodigo, 
    			@Tcodigo = @Tcodigo, 
    			@cantdias = @cantdias, 
    			@CantDiasMensual = @CantDiasMensual,
    			@CantPagosRealizados = @CantPagosRealizados,
    			@Factor = @Factor,
    			@per = @per,
    			@mes = @mes,
    			@IRcodigo = @IRcodigo,
    			@RCdesde = @RCdesde,
    			@RChasta = @RChasta
    	end 
    	else begin
    		exec rh_CalculoNominaRentaPR
    			@RCNid = @RCNid, 
    			@Ecodigo = @Ecodigo, 
    			@Tcodigo = @Tcodigo, 
    			@cantdias = @cantdias, 
    			@CantDiasMensual = @CantDiasMensual,
    			@CantPagosRealizados = @CantPagosRealizados,
    			@Factor = @Factor,
    			@per = @per,
    			@mes = @mes,
    			@IRcodigo = @IRcodigo,
    			@RCdesde = @RCdesde,
    			@RChasta = @RChasta
    	end
    end    

	/**************************************************************************************
	** De aqui en adelante corresponde al calculo de Deducciones Especiales              **
	**************************************************************************************/
	declare @TDid numeric, @script varchar(4096)
	declare cDeducciones cursor
	for 
		select distinct b.TDid
		from DeduccionesCalculo a, DeduccionesEmpleado b, FDeduccion f
		where a.RCNid = @RCNid
		  and b.Did = a.Did
		  and f.TDid = b.TDid
	for read only
	open cDeducciones
	while (1=1) begin
		fetch cDeducciones into @TDid
		if @@sqlstatus != 0 begin
			close cDeducciones
			deallocate cursor cDeducciones
			break
		end
		select @script = "declare @RCNid numeric, @TDid numeric, @minimo money "
		select @script = @script || "select @RCNid = " || convert(varchar, @RCNid) 
		select @script = @script || " , @TDid = " || convert(varchar, @TDid) 
		select @script = @script || " , @minimo = " || convert(varchar, @minimo)
		select @script = @script || " " 
		select @script = @script || convert(varchar(4096),FDformula)
		from FDeduccion
		where TDid = @TDid
        
		if datalength(@script) < 200
			continue
            
		exec (@script)
        
		if @@error != 0 begin
			raiserror 40001 "Error Procesando Deduccion Especial! Proceso Cancelado!."
			return -1
		end
	end
	/* Fin de calculo de Deducciones Especiales */
	-- Si el valor de la deduccion a rebajar es mayor que el saldo, se toma el valor del saldo
	update DeduccionesCalculo 
		set DCvalor = a.Dsaldo, DCinteres = 0.00
	from SalarioEmpleado d, DeduccionesEmpleado a 
	where DeduccionesCalculo.RCNid = @RCNid
	  and DeduccionesCalculo.RCNid = d.RCNid
	  and DeduccionesCalculo.DEid = d.DEid

	  and d.SEcalculado = 0
	  and (@pDEid is null or d.DEid = @pDEid)
	  and a.Did = DeduccionesCalculo.Did
	  and a.DEid = DeduccionesCalculo.DEid
	  and a.Dcontrolsaldo > 0
	  and a.Dsaldo < DeduccionesCalculo.DCvalor

	-- Actualizar Cargas en SalarioEmpleado
	update SalarioEmpleado 
	set 
		SEcargasempleado = isnull((
			select sum(a.CCvaloremp)
			from CargasCalculo a
			where a.DEid = c.DEid
			  and a.RCNid = c.RCNid
			),0.00),
		SEcargaspatrono = isnull((
			select sum(a.CCvalorpat)
			from CargasCalculo a
			where a.DEid = c.DEid
			  and a.RCNid = c.RCNid
			),0.00)
	from SalarioEmpleado c
	where c.RCNid = @RCNid
	  and c.SEcalculado = 0
	  and (@pDEid is null or c.DEid = @pDEid)

	--  Actualizar la Tabla SalarioEmpleado para poner Deducciones
	update SalarioEmpleado set 
		SEdeducciones = isnull(( 
			select sum(a.DCvalor)
			from DeduccionesCalculo a
			where a.DEid = c.DEid
			  and a.RCNid = c.RCNid
			),0.00)
	from SalarioEmpleado c
	where c.RCNid = @RCNid
	  and c.SEcalculado = 0
	  and (@pDEid is null or c.DEid = @pDEid)

    update SalarioEmpleado set 
		SEsalariobruto = round(SEsalariobruto,2),
		SEincidencias = round(SEincidencias,2),
		SErenta = round(SErenta,2),
		SEcargasempleado = round(SEcargasempleado,2),
		SEcargaspatrono = round(SEcargaspatrono,2),
		SEdeducciones = round(SEdeducciones,2)
	where RCNid = @RCNid
	  and SEcalculado = 0
	  and (@pDEid is null or DEid = @pDEid)

	update SalarioEmpleado 
		set SEliquido = round(SEsalariobruto + SEincidencias - SErenta - SEcargasempleado - SEdeducciones,2)
	where RCNid = @RCNid
	  and SEcalculado = 0
	  and (@pDEid is null or DEid = @pDEid)

	/* Prioridades de Deducciones */
	if not exists(
		select 1 
		from CalendarioPagos a, CalendarioPagos b 
		where a.CPid = @RCNid
		  and b.Ecodigo = a.Ecodigo
		  and b.Tcodigo = a.Tcodigo
		  and b.CPdesde < a.CPdesde
		  and b.CPfcalculo is null) 
	begin
		if exists (select 1 from SalarioEmpleado where RCNid = @RCNid and SEcalculado = 0 and (@pDEid is null or DEid = @pDEid) and SEliquido < 0.00) begin
			exec @error = rh_ProcesaDeducciones @RCNid = @RCNid, @debug = @debug
			if @error != 0 begin
				raiserror 40001 "Error Procesando las Prioridades de las Deducciones! Proceso Cancelado!."
				return -1
			end
		end
	end
	
    if @debug = 'S' begin
		select @factored, @tipored
	end 

	if @factored > 0 begin
		if @tipored = 1 begin        
			/* Redondeo a la unidad de pago parametrizada. Solo si la unidad de pago es mayor a cero */
			insert IncidenciasCalculo 
				(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, 
				ICmontores, CFid)
			select 
				@RCNid, DEid, @idincidenciared, @RChasta, 1, getdate(), @Usucodigo, @Ulocalizacion, 0, null, 0.00, 
				round(round(SEliquido / @factored, 0) * @factored,2) - SEliquido, 
				(select case when p.CFidconta is null then p.CFid else p.CFidconta end
				from PagosEmpleado a, RHPlazas p 
				where a.RCNid = SalarioEmpleado.RCNid
				  and a.DEid = SalarioEmpleado.DEid 
				  and a.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = a.RCNid and b.DEid = a.DEid)
                  and a.PEtiporeg != 2                  
				  and p.RHPid = a.RHPid
				)
			from SalarioEmpleado 
			where RCNid = @RCNid
			  and SEcalculado = 0
			  and (@pDEid is null or DEid = @pDEid)
			  and SEliquido != round(round(SEliquido / @factored, 0) * @factored,2)
              
			update SalarioEmpleado set 
				SEliquido = round(round(SEliquido / @factored, 0) * @factored,2),
				SEincidencias = SEincidencias + (round(round(SEliquido / @factored, 0) * @factored,2) - SEliquido)
			where RCNid = @RCNid
			  and SEcalculado = 0
			  and (@pDEid is null or DEid = @pDEid)
			  and SEliquido != round(round(SEliquido / @factored, 0) * @factored,2)
		end
		else begin
			insert IncidenciasCalculo 
				(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, 
				ICmontores, CFid)
			select 
				@RCNid, DEid, @idincidenciared, @RChasta, 1, getdate(), @Usucodigo, @Ulocalizacion, 0, null, 0.00, 
				round(ceiling(SEliquido / @factored) * @factored,2) - SEliquido, 
				(select case when p.CFidconta is null then p.CFid else p.CFidconta end
				from PagosEmpleado a, RHPlazas p 
				where a.RCNid = SalarioEmpleado.RCNid
				  and a.DEid = SalarioEmpleado.DEid 
				  and a.PEdesde = (select max(b.PEdesde) from PagosEmpleado b where b.RCNid = a.RCNid and b.DEid = a.DEid)
				  and p.RHPid = a.RHPid
				)
			from SalarioEmpleado 
			where RCNid = @RCNid
			  and SEcalculado = 0
			  and (@pDEid is null or DEid = @pDEid)
			  and SEliquido != round(ceiling(SEliquido / @factored) * @factored,2)
        
			update SalarioEmpleado set 
				SEliquido = round(ceiling(SEliquido / @factored) * @factored,2),
				SEincidencias = SEincidencias + (round(ceiling(SEliquido / @factored) * @factored,2) - SEliquido)
			where RCNid = @RCNid
			  and SEcalculado = 0
			  and (@pDEid is null or DEid = @pDEid)
			  and SEliquido != round(ceiling(SEliquido / @factored) * @factored,2)
		end
	end

    -- Calendario de Pagos anterior
    select @CPidant = a.CPid
    from CalendarioPagos a
    where a.Ecodigo = @Ecodigo 
      and a.CPdesde = (select max(b.CPdesde) from CalendarioPagos b where b.Ecodigo = a.Ecodigo and b.Tcodigo = a.Tcodigo and b.CPdesde < @RCdesde)
      and Tcodigo = @Tcodigo

    -- Si la Nómina anterior está en la historia o si es la primer nómina que se paga (estaría nula la variable @CPidant)
	if exists(select 1 from HRCalculoNomina where Ecodigo = @Ecodigo and Tcodigo = @Tcodigo and RCNid = @CPidant) or @CPidant is null
	begin
		--Cambiar el Status de Calculado a todos los Empleados
		update SalarioEmpleado set SEcalculado = 1
		where RCNid = @RCNid
		  and SEcalculado = 0
		  and (@pDEid is null or DEid = @pDEid)
		  and SEliquido >= 0.00
	end
      
end
