create procedure rh_RelacionCalculo
    @Ecodigo int,
    @RCNid numeric,
    @Usucodigo numeric,
    @Ulocalizacion char(2) = '00',
    @pDEid numeric = null,
    @debug char(1) = 'N'
as
/*
** Carga los datos requeridos para una Relación de Cálculo de Nómina
** Hecho por: Marcel de Mézerville L.
** Fecha: 03 Junio 2003
*/
create table #PagosEmpleado(
    RCNid numeric not null,  
    DEid numeric not null,
    PEbatch numeric null,
    PEdesde datetime not null,
    PEhasta datetime not null,
    PEsalario money not null,
    PEcantdias int not null,
    PEmontores money not null,
    PEmontoant money not null,
    cortedesde datetime null,
    cortehasta datetime null,
    Tcodigo    char(5) not null,
    RHTid      numeric not null,
    Ocodigo    int not null,
    Dcodigo    int not null,
    RHPid      numeric not null,
    RHPcodigo  char(10) not null,
    RVid       numeric not null,
    LTporcplaza float null,
    LTid numeric not null,
    RHJid numeric not null,
    PEhjornada float not null,
    PEtiporeg int default 0 not null,
    CPid numeric null
    )
create table #CalendariosEmpleado (
	CPid numeric not null, 
	DEid numeric not null, 
	CPdesde datetime not null,
	CPhasta datetime not null
)
/* Tabla de control de los montos a rebajar */
create table #IncidenciasReb (
 RCNid             numeric, 
 DEid              numeric, 
 CIid              numeric, 
 ICfecha           datetime,
 ICvalor           money,   
 ICfechasis        datetime,
 CFid              numeric, 
 RHSPEid           numeric,
 diassalario       money,
 saldoreb          money,
 saldosub          money,
 dias              money,
 diasacum          money,
 diasant		   money
)
create table #EmpleadosNomina (
   DEid        numeric,
   dias        int
)
declare 
    @RCdesde datetime,
    @RChasta datetime,
    @Tcodigo char(5),
    @IRcodigo char(5),
    @error int,
    @cantdias int,
    @CantDiasMensual int,
    @DiasAjuste int,
    @DiasMes int,
    @Ttipopago int,
    @CantDiasParametro int,
    @fechacalculo datetime,
    @fecha datetime,
    @indicadornopago char(1),
    @CPid numeric,
    @CPtipo int,
	@dia1 datetime,
    @ContabilizaGastosMes int
    
begin
    select @error = 0, @fechacalculo = getdate()
    
    select 
        @RCdesde = a.RCdesde,
        @RChasta = a.RChasta,
        @Tcodigo = a.Tcodigo,
        @Ttipopago = b.Ttipopago
    from RCalculoNomina a, TiposNomina b
    where a.RCNid = @RCNid
      and a.Ecodigo = b.Ecodigo
	  and a.Tcodigo = b.Tcodigo
      
    select @CPtipo = CPtipo
    from CalendarioPagos
    where CPid = @RCNid
    select @cantdias = isnull(convert(int, b.Pvalor),0)
    from TiposNomina a, RHParametros b
    where a.Ecodigo = @Ecodigo
      and a.Tcodigo = @Tcodigo
      and a.Ecodigo = b.Ecodigo
      and b.Pcodigo = case when a.Ttipopago = 0 then 40 when a.Ttipopago = 1 then 50 when a.Ttipopago = 2 then 60 when a.Ttipopago = 4 then 70 else -1 end
    -- Obtener la cantidad de días máximo según tipo de Nómina
	SELECT @CantDiasMensual = convert(int,Pvalor)
	FROM RHParametros
	WHERE Ecodigo = @Ecodigo
  	  AND Pcodigo = 80
	IF @CantDiasMensual is null BEGIN
		RAISERROR 40000 "Error, no se ha definido la cantidad de días a utilizar para el cálculo de la nómina mensual en los parámetros del Sistema. Proceso Cancelado."
		RETURN -1
	END
	IF @debug = "S" BEGIN
		PRINT "DIAS PARA CALCULO DE SALARIO %1!", @CantDiasMensual
	END
    select @IRcodigo = Pvalor
    from RHParametros
    where Ecodigo = @Ecodigo
      and Pcodigo = 30
    
    if @IRcodigo is null begin
        raiserror 40000 'Error!, No se ha definido la Tabla de Impuesto de Renta a utilizar en los parámetros del Sistema. Proceso Cancelado!!'
        return -1
    end
    if (select count(1) 
                  from EImpuestoRenta b 
                  where b.IRcodigo = @IRcodigo
                    and b.EIRestado = 1
                    and @RCdesde between b.EIRdesde and b.EIRhasta
                    and @RChasta between b.EIRdesde and b.EIRhasta
                  ) = 0
    begin
        raiserror 40000 'Error!, el rango de fechas de la Relación de Cálculo de Nómina no está contenido en la Tabla de Impuesto de Renta. Proceso Cancelado!!'
        return -1
    end
    if @pDEid is not null begin
        -- Inserta los Pagos de Empleados para el Tipo de Nómina de la relación
        insert #PagosEmpleado (RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid)
        select @RCNid, a.DEid, null, a.LTdesde, a.LThasta,  case when b.RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 0, case when RHTpaga = 1 then  round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.LTporcplaza, a.LTid, a.RHJid, RHJhoradiaria, 0, @RCNid
        from LineaTiempo a, RHTipoAccion b, RHJornadas c
        where a.Ecodigo = @Ecodigo
          and a.Tcodigo = @Tcodigo
          and a.DEid = @pDEid
          and a.Ecodigo = b.Ecodigo
          and a.RHTid = b.RHTid
          and a.RHJid = c.RHJid
          and ((a.LThasta >= @RCdesde and a.LTdesde <= @RChasta) or (a.LTdesde <= @RChasta and a.LThasta >= @RCdesde))
        if @CPtipo = 0 begin          
            insert #CalendariosEmpleado(CPid, DEid, CPdesde, CPhasta)
            select distinct e.CPid, @pDEid, e.CPdesde, e.CPhasta
            from LineaTiempo a, CalendarioPagos d, CalendarioPagos e
            where a.Ecodigo = @Ecodigo
              and a.Tcodigo = @Tcodigo
              and a.DEid = @pDEid
              and a.CPid = @RCNid
              and d.Ecodigo = a.Ecodigo
              and d.Tcodigo = a.Tcodigo
              and a.LTdesde between d.CPdesde and d.CPhasta 
              and d.CPhasta < @RCdesde
              and e.CPhasta < @RCdesde
              and e.Ecodigo = d.Ecodigo
              and e.Tcodigo = d.Tcodigo
              and e.CPdesde >= d.CPdesde
              and e.CPtipo = 0
              and d.CPtipo = 0                            
        end
    end
    else begin
        -- Inserta los Pagos de Empleados para el Tipo de Nómina de la relación
        insert #PagosEmpleado (RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid)
        select @RCNid, a.DEid, null, a.LTdesde, a.LThasta, case when b.RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 0, case when RHTpaga = 1 then  round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, a.RVid, a.LTporcplaza, a.LTid, a.RHJid, c.RHJhoradiaria, 0, @RCNid
        from LineaTiempo a, RHTipoAccion b, RHJornadas c
        where a.Ecodigo = @Ecodigo
          and a.Tcodigo = @Tcodigo
          and a.Ecodigo = b.Ecodigo
          and a.RHTid = b.RHTid
          and a.RHJid = c.RHJid
          and ((a.LThasta >= @RCdesde and a.LTdesde <= @RChasta) or (a.LTdesde <= @RChasta and a.LThasta >= @RCdesde))
          
        if @CPtipo = 0 begin
            insert #CalendariosEmpleado(CPid, DEid, CPdesde, CPhasta)
            select distinct e.CPid, a.DEid, e.CPdesde, e.CPhasta
            from LineaTiempo a, CalendarioPagos d, CalendarioPagos e
            where a.Ecodigo = @Ecodigo
              and a.Tcodigo = @Tcodigo
              and a.CPid = @RCNid
              and d.Ecodigo = a.Ecodigo
              and d.Tcodigo = a.Tcodigo
              and a.LTdesde between d.CPdesde and d.CPhasta 
              and d.CPhasta < @RCdesde
              and e.CPhasta < @RCdesde
              and e.Ecodigo = d.Ecodigo
              and e.Tcodigo = d.Tcodigo
              and e.CPdesde >= d.CPdesde
              and e.CPtipo = 0
              and d.CPtipo = 0   
        end
    end      
    --Retroactivos positivos para el primer corte 
    insert #PagosEmpleado (
	RCNid, DEid, PEbatch, 
	PEdesde, 
	PEhasta, 
	PEsalario, 
	PEcantdias, 
	PEmontores, 
	PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
	RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid
	)
    select distinct 
	@RCNid, ce.DEid, null, 
	case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
	case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta end, 
	case when b.RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 
	0, 
	case when RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 
	0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
	a.RVid, a.LTporcplaza, a.LTid, a.RHJid, RHJhoradiaria, 1, ce.CPid
    from #CalendariosEmpleado ce, LineaTiempo a, RHTipoAccion b, RHJornadas c
    where a.Ecodigo = @Ecodigo
      and a.Tcodigo = @Tcodigo
      and a.DEid = ce.DEid
      and (select min(g.CPdesde) from #CalendariosEmpleado g where g.DEid = ce.DEid) between a.LTdesde and a.LThasta
      and a.LThasta >= ce.CPdesde
      and a.LTdesde < (select min(g.CPdesde) from #CalendariosEmpleado g where g.DEid = ce.DEid)
      and a.LTdesde < @RCdesde
      and a.Ecodigo = b.Ecodigo
      and a.RHTid = b.RHTid
      and a.RHJid = c.RHJid
    --  Retroactivos positivos con corte posterior al primer dia del mes seleccionado
    insert #PagosEmpleado (
	RCNid, DEid, PEbatch, 
	PEdesde, 
	PEhasta, 
	PEsalario, 
	PEcantdias, 
	PEmontores, 
	PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
	RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid
	)
    select distinct 
	@RCNid, ce.DEid, null, 
	case when ce.CPdesde > a.LTdesde then ce.CPdesde else a.LTdesde end, 
	case when a.LThasta < ce.CPhasta then a.LThasta else ce.CPhasta  end, 
	case when b.RHTpaga = 1 then round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 
	0, 
	case when RHTpaga = 1 then  round(a.LTsalario * isnull(LTporcsal,100)/100,2) else 0.00 end, 
	0.00, a.LTdesde, a.LThasta, a.Tcodigo, a.RHTid, a.Ocodigo, a.Dcodigo, a.RHPid, a.RHPcodigo, 
	a.RVid, a.LTporcplaza, a.LTid, a.RHJid, RHJhoradiaria, 1, ce.CPid
    from #CalendariosEmpleado ce, LineaTiempo a, RHTipoAccion b, RHJornadas c
    where a.Ecodigo = @Ecodigo
      and a.Tcodigo = @Tcodigo
      and a.DEid = ce.DEid
      and a.LTdesde >= (select min(g.CPdesde) from #CalendariosEmpleado g where g.DEid = ce.DEid)
      and a.LThasta >= ce.CPdesde
      and a.LTdesde <= ce.CPhasta
      and a.LTdesde < @RCdesde
      and a.Ecodigo = b.Ecodigo
      and a.RHTid = b.RHTid
      and a.RHJid = c.RHJid
    --  3. Retroactivos negativos
    insert #PagosEmpleado (
	RCNid, DEid, PEbatch, 
	PEdesde, 
	PEhasta, 
	PEsalario, 
	PEcantdias, 
	PEmontores, 
	PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, 
	RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid
	)
    select 
	@RCNid, ce.DEid, null, 
	e.PEdesde, 
	e.PEhasta, 
	abs(e.PEsalario), 
	sum(case when e.PEmontores > 0 then abs(e.PEcantdias) * -1 else abs(e.PEcantdias) end), 
	sum(e.PEmontores*-1), 
	0.00, e.PEdesde, e.PEhasta, e.Tcodigo, e.RHTid, e.Ocodigo, e.Dcodigo, e.RHPid, e.RHPcodigo, 
	e.RVid, 100, 0, e.RHJid, e.PEhjornada, 2, 733
    from #CalendariosEmpleado ce, HPagosEmpleado e
    where e.Tcodigo = @Tcodigo
      and e.DEid = ce.DEid
      and e.RCNid = ce.CPid
      and e.PEdesde >= (select min(g.CPdesde) from #CalendariosEmpleado g where g.DEid = ce.DEid)
      and e.PEhasta < @RCdesde
      and e.PEmontores != 0.00
    group by ce.DEid, e.PEdesde, e.PEhasta, abs(e.PEsalario), e.Tcodigo, e.RHTid, e.Ocodigo, e.Dcodigo, e.RHPid, e.RHPcodigo, e.RVid, e.RHJid, e.PEhjornada
    having sum(e.PEmontores*-1) != 0
    if @debug = "S" begin
       select CPid, DEid, CPdesde, CPhasta
       from #CalendariosEmpleado where DEid = isnull(@pDEid,DEid) 
       order by DEid, CPdesde
       select RCNid, DEid, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg, CPid 
       from #PagosEmpleado where DEid = isnull(@pDEid,DEid) 
       order by PEtiporeg, PEdesde
    end
    update #PagosEmpleado set PEdesde = @RCdesde 
    where PEtiporeg = 0 
      and PEdesde < @RCdesde
      
    update #PagosEmpleado set PEhasta = @RChasta 
    where PEtiporeg = 0 
      and PEhasta > @RChasta
    update #PagosEmpleado set PEhasta = dateadd(dd,-1, @RCdesde) 
    where PEtiporeg != 0 
      and PEhasta > @RCdesde
    --Eliminar Empleados Cesados en esta Nomina
    delete #PagosEmpleado 
    where exists ( 
            select 1  
            from DLaboralesEmpleado a, RHTipoAccion b 
            where a.DEid = #PagosEmpleado.DEid 
              and a.Ecodigo = @Ecodigo 
              and a.DLfvigencia >= #PagosEmpleado.PEdesde
              and a.RHTid = b.RHTid 
              and b.RHTcomportam = 2 --CESE
              and b.RHTliquidatotal = 1 --Se Paga el total de los dias laborados en la liquidacion 
    ) 
    -- Para tomar en cuenta los días que no se pagan.  Utiliza Indicador de Días de NO pago
    select @indicadornopago = isnull(ltrim(rtrim(Pvalor)),'N')
    from RHParametros where Ecodigo = @Ecodigo
      and Pcodigo = 90
      
    if @indicadornopago = 'S' and @CPtipo = 0 begin 
        select @fecha = min(PEdesde) from #PagosEmpleado
    
        if @fecha is null 
        	select @fecha = @RCdesde
        while @fecha <= @RChasta begin 
            if exists (select 1 from DiasTiposNomina where Ecodigo = @Ecodigo and Tcodigo = @Tcodigo and datepart(dw, @fecha) = DTNdia)  begin
                insert #PagosEmpleado (RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg)
                select RCNid, DEid, PEbatch, dateadd(dd, 1, @fecha), PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg
                from #PagosEmpleado
                where @fecha between PEdesde and PEhasta
                  and PEhasta > @fecha
                  and PEtiporeg < 2
                insert #PagosEmpleado (RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg)
                select RCNid, DEid, PEbatch, @fecha, @fecha, PEsalario, 1, 0.00, 0.00, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, 3
                from #PagosEmpleado
                where @fecha between PEdesde and PEhasta
                  and PEhasta >= @fecha
                  and PEtiporeg < 2
                update #PagosEmpleado
                set PEhasta = dateadd(dd, -1, @fecha)
                where @fecha between PEdesde and PEhasta
                  and PEdesde < @fecha
                  and PEtiporeg < 2
                --Elimina el registro que inicia en la fecha que se está procesando
                delete #PagosEmpleado
                where @fecha between PEdesde and PEhasta 
                  and PEdesde = @fecha
                  and PEhasta > @fecha 
                  and PEtiporeg < 2 
                  
                update #PagosEmpleado
                set PEmontores = 0.00,
                    PEtiporeg = 3
                where @fecha between PEdesde and PEhasta
                  and PEdesde = @fecha
                  and PEhasta = @fecha
                  and PEdesde = PEhasta
                  and PEmontores != 0.00
                  and PEtiporeg < 2
            end
            select @fecha = dateadd(dd, 1, @fecha)
        end --del while
    end -- del indicador de dias de NO pago
    /*************************************************************************************
        Modificado por Yu Hui 
        Fecha: 23 de Diciembre 2005
    **************************************************************************************/
    -- Averiguar si se requiere contabilizar los gastos por mes
    select @ContabilizaGastosMes = coalesce(convert(int, Pvalor), 0)
    from RHParametros
    where Ecodigo = @Ecodigo
    and Pcodigo = 490
    
    -- Realizar los cortes para los pagos que cubren diferentes meses contables
    if @ContabilizaGastosMes = 1 and @Ttipopago in (0,1) and (datepart(mm, @RCdesde) != datepart(mm, @RChasta)) begin
        select @dia1 = convert(varchar, datepart(yy, @RChasta)) || replicate('0', 2-char_length(convert(varchar, datepart(mm, @RChasta)))) || convert(varchar, datepart(mm, @RChasta)) || '01'
        
        insert #PagosEmpleado (RCNid, DEid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg)
        select RCNid, DEid, PEbatch, @dia1, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, cortedesde, cortehasta, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg
        from #PagosEmpleado
        where PEdesde < @dia1
          and PEhasta >= @dia1
          and PEtiporeg < 2
          
        update #PagosEmpleado
        set PEhasta = dateadd(dd, -1, @dia1)
        where PEdesde < @dia1
          and PEhasta >= @dia1
          and PEtiporeg < 2
          
    end
    /*************************************************************************************
        Fin Modificaciones
    **************************************************************************************/
        
    -- La cantidad de días resultante por cada funcionario no puede ser mayor que la cantidad de días segun tipo de Nómina
    update #PagosEmpleado set PEcantdias = datediff(dd,PEdesde,PEhasta) + 1
	SELECT @DiasAjuste = 0, @DiasMes = 0
    
	-- PARA NOMINAS MENSUALES ES NECESARIO AJUSTAR LOS 31 Y LOS 28. OBTENER LA CANTIDAD DE DIAS QUE SE REQUIERE AJUSTAR A LOS PERIODOS
	SELECT @CantDiasParametro = @CantDiasMensual
	IF @Ttipopago in (2,3) BEGIN
        
		IF @Ttipopago = 2 BEGIN
			SELECT @CantDiasParametro = ceiling(convert(money,@CantDiasParametro) / 2)
		END
        
        select @CPid = -1
        while @CPid is not null begin
            select @CPid = min(CPid) 
            from #PagosEmpleado
            where CPid > @CPid
              and PEtiporeg < 2
            
            if @CPid is null
                break
                
    		SELECT @DiasMes = DATEDIFF(dd,CPdesde, CPhasta) + 1
            from CalendarioPagos
            where CPid = @CPid
		    SELECT @DiasAjuste = 0
    		IF @DiasMes > @CantDiasParametro BEGIN
    				SELECT @DiasAjuste = (@DiasMes - @CantDiasParametro ) * -1
    		END
    		IF @DiasMes < @CantDiasParametro BEGIN
    			SELECT @DiasAjuste = (@DiasMes - @CantDiasParametro )  * -1
    		END
    		if @DiasAjuste < 0 begin
    			update #PagosEmpleado 
    			set PEcantdias = PEcantdias + @DiasAjuste
    			from CalendarioPagos
    			WHERE #PagosEmpleado.CPid = @CPid
                  and #PagosEmpleado.PEhasta > dateadd(dd, @DiasAjuste, CalendarioPagos.CPhasta)
    			  and CalendarioPagos.CPid = @CPid
                  and #PagosEmpleado.PEtiporeg < 2
    		end
    		if @DiasAjuste > 0 begin
    			update #PagosEmpleado 
    			set PEcantdias = PEcantdias + @DiasAjuste
    			from CalendarioPagos
    			WHERE #PagosEmpleado.CPid = @CPid
    			  and CalendarioPagos.CPid = @CPid
                  and #PagosEmpleado.PEhasta = CalendarioPagos.CPhasta
                  and #PagosEmpleado.PEtiporeg < 2
    		end
       end --while
	END
    update #PagosEmpleado set PEmontores = round((PEmontores / @CantDiasMensual) * PEcantdias, 2) where PEmontores != 0.00 and PEtiporeg < 2
begin tran 
     if @pDEid is not null begin
        delete IncidenciasCalculo where RCNid = @RCNid and DEid = @pDEid
        delete PagosEmpleado where RCNid = @RCNid and DEid = @pDEid
        delete CargasCalculo where RCNid = @RCNid and DEid = @pDEid 
        delete DeduccionesCalculo where RCNid = @RCNid and DEid = @pDEid
        delete SalarioEmpleado where RCNid = @RCNid and DEid = @pDEid
     end
     else begin
        delete IncidenciasCalculo where RCNid = @RCNid 
        delete PagosEmpleado where RCNid = @RCNid 
        delete CargasCalculo where RCNid = @RCNid 
        delete DeduccionesCalculo where RCNid = @RCNid 
        delete SalarioEmpleado where RCNid = @RCNid 
     end
        
     insert #EmpleadosNomina (DEid, dias)   --- Obtener los dias trabajados por cada empleado en la nomina actual.
     select distinct DEid, 0
     from #PagosEmpleado
     if @CPtipo != 0 begin                  --- No hay pagos de salario en nominas especiales
        delete #PagosEmpleado
     end
     update #EmpleadosNomina
     set dias = isnull(
        (select sum(PEcantdias)
         from #PagosEmpleado 
         where #PagosEmpleado.DEid = #EmpleadosNomina.DEid
           and #PagosEmpleado.PEtiporeg = 0
           and #PagosEmpleado.PEmontores != 0.00), 0)
      /* SalarioEmpleado */
     insert SalarioEmpleado (RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinorenta, SEinocargas, SEinodeduc)
     select @RCNid, DEid, 0, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00
     from #EmpleadosNomina
     /* Pagos Empleado */
     insert PagosEmpleado (DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg)
     select DEid, RCNid, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, LTporcplaza, LTid, RHJid, PEhjornada, PEtiporeg
     from #PagosEmpleado
         
     if @CPtipo = 0 begin
         -- Insertar como Incidencias los componentes Salariales que se pagan independientes del salario bruto
        insert IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid)
        select @RCNid, b.DEid, ld.CIid, b.PEdesde, ld.DLTmonto * b.PEcantdias / @CantDiasMensual, getdate(), @Usucodigo, @Ulocalizacion, 0, null, 0.00, 0.00 as ICmontores, coalesce(p.CFidconta, p.CFid)
        from #PagosEmpleado b, LineaTiempo lt, DLineaTiempo ld, ComponentesSalariales a, RHPlazas p
        where  b.PEtiporeg <> 3  --- No tomar en cuenta los dias que no se pagan. Caso Nacion
          and lt.DEid = b.DEid
          and b.PEdesde between lt.LTdesde and lt.LThasta
          and ld.LTid = lt.LTid
          and ld.CIid is not null
          and a.CSid = ld.CSid
          and p.RHPid = lt.RHPid
       -- Insertar Incidencias de este pago correspondientes a valores que se calculan con respecto al salario del empleado Ej: horas extra
       insert IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid)
       select @RCNid, a.DEid, a.CIid, a.Ifecha, a.Ivalor, getdate(), a.Usucodigo, a.Ulocalizacion, 0, null, 0.00, 0.00, coalesce(a.CFid, coalesce(p.CFidconta, p.CFid)), a.Iid
       from #EmpleadosNomina b, Incidencias a, CIncidentes c, RHPlazas p, LineaTiempo lt
       where a.DEid = b.DEid
         and a.Ifecha <= @RChasta
         and a.Iespecial = 0
         and c.CIid = a.CIid
         and c.CItipo < 2
         and lt.DEid = b.DEid
         and a.Ifecha between lt.LTdesde and lt.LThasta
         and p.RHPid = lt.RHPid
         and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha and ic.Iid = a.Iid)
       -- Insertar Incidencias no pagadas que corresponden a importe o a cálculo de cualquier nómina igual o anterior a la que se está procesando Ej: Comisiones
       insert IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid)
       select @RCNid, a.DEid, a.CIid, a.Ifecha, a.Ivalor, getdate(), a.Usucodigo, a.Ulocalizacion, 0, null, 0.00, 0.00, isnull(a.CFid, isnull(p.CFidconta, p.CFid)), a.Iid
       from #EmpleadosNomina b, Incidencias a, CIncidentes c, LineaTiempo lt, RHPlazas p
       where a.DEid = b.DEid
         and a.Ifecha <= @RChasta
         and a.Iespecial = 0
         and c.CIid = a.CIid
         and c.CItipo > 1
         and lt.DEid = a.DEid
         and a.Ifecha between lt.LTdesde and lt.LThasta
         and p.RHPid = lt.RHPid
         and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha)
       -- Insertar todos los conceptos de cálculo retroactivos Ej: Horas pagadas en nóminas anteriores
       insert IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid)
       select @RCNid, a.DEid, a.CIid, a.ICfecha, min(a.ICvalor), getdate(), @Usucodigo, @Ulocalizacion, 0, null, sum(round(a.ICmontores - a.ICmontoant,2)), 0.00 as ICmontores, min(isnull(a.CFid, isnull(p.CFidconta, p.CFid)))
       from #PagosEmpleado b, HIncidenciasCalculo a, CIncidentes c, RHPlazas p
       where b.PEtiporeg = 1
         and a.DEid = b.DEid
         and a.ICfecha between b.PEdesde and b.PEhasta
         and a.ICvalor != 0.00
         and c.CIid = a.CIid
         and c.CItipo < 2
         and p.RHPid = b.RHPid
         group by a.DEid, a.CIid, a.ICfecha
        -- Insertar los datos de Subsidios / Rebajos vigentes en la tabla RHSaldoPagosExceso cuando la nomina es normal.
        insert #IncidenciasReb (
            RCNid, DEid, CIid, ICfecha, ICvalor,  ICfechasis, CFid, RHSPEid, diassalario, saldoreb, saldosub, dias, diasacum, diasant)
        select 
            @RCNid, pe.DEid, ta.CIncidente1, @RCdesde, RHSPEsaldiario, getdate(), isnull(p.CFidconta, p.CFid), RHSPEid, 0, pe.RHSPEsaldo, pe.RHSPEsaldosub, dias = round(RHSPEsaldo / RHSPEsaldiario, 2), diasacum = 0, diasant = 0
        from #EmpleadosNomina b, RHSaldoPagosExceso pe, RHTipoAccion ta, LineaTiempo lt, RHPlazas p
        where pe.DEid = b.DEid
          and pe.Ecodigo = @Ecodigo
          and abs(pe.RHSPEsaldo) >= 0.01
          and pe.RHSPEfdesdesig <= @RChasta
          and ta.RHTid = pe.RHTid
          and lt.DEid = pe.DEid
          and pe.RHSPEfdesde between lt.LTdesde and lt.LThasta
          and p.RHPid = lt.RHPid
    end
    else begin
		-- Insertar todas las incidencias de la relación de cálculo especial que esten definidas en el calendario
		insert IncidenciasCalculo (RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid, Iid)
		select @RCNid, a.DEid, a.CIid, a.Ifecha, a.Ivalor, getdate(), a.Usucodigo, a.Ulocalizacion, 0, null, 0.00, 0.00, isnull(a.CFid, isnull(p.CFidconta, p.CFid)), a.Iid
		from 
			#EmpleadosNomina b, 
			Incidencias a, 
			LineaTiempo lt, 
			RHPlazas p, 
			CalendarioPagos cp, 
			CCalendario cc,
			CIncidentes c
		where a.DEid = b.DEid
		  and a.Ifecha <= @RChasta
		  and lt.DEid = a.DEid
		  and a.Ifecha between lt.LTdesde and lt.LThasta
		  and p.RHPid = lt.RHPid
		  and cp.CPid = @RCNid
		  and cc.CPid = cp.CPid
		  and c.CIid = cc.CIid
		  and c.CIid = a.CIid
		  and c.CItipo > 1             --Cálculo e Importe
		  and not exists(select 1 from IncidenciasCalculo ic where ic.DEid = a.DEid and ic.CIid = a.CIid and ic.ICfecha = a.Ifecha)
    end
        
    -- Calculo de los pagos a Subsidiar / Rebajar que se encuentren activos en la tabla RHSaldoPagosExceso
    update #IncidenciasReb
    set dias = datediff(dd, RHSPEfdesdesig, @RChasta) + 1
    from RHSaldoPagosExceso pe
    where pe.RHSPEid = #IncidenciasReb.RHSPEid
      and pe.RHSPEfdesdesig between @RCdesde and @RChasta
      and pe.RHSPEfdesdesig > @RCdesde
      and pe.RHSPEfhasta > @RChasta
      and pe.RHSPEfdesde = pe.RHSPEfdesdesig
    update #IncidenciasReb
    set diasacum = dias + isnull((select sum(dias) from #IncidenciasReb b where b.DEid = #IncidenciasReb.DEid and b.RHSPEid < #IncidenciasReb.RHSPEid), 0)
    update #IncidenciasReb
    set diasant = diasacum - dias
    delete #IncidenciasReb
    from #EmpleadosNomina e
    where #IncidenciasReb.DEid = e.DEid
      and #IncidenciasReb.diasant > e.dias
    update #IncidenciasReb
    set diassalario = 
        case when diasacum >= b.dias then b.dias - diasant else diasacum - diasant end
    from #EmpleadosNomina b
    where b.DEid = #IncidenciasReb.DEid
    /* 1. Monto a Rebajar de la tabla de RHSaldoPagosExceso */
    insert IncidenciasCalculo (
        RCNid, DEid, CIid, ICfecha, 
        ICvalor, 
        ICfechasis, Usucodigo, Ulocalizacion, 
        ICcalculo, ICbatch, ICmontoant, ICmontores, 
        CFid, RHSPEid)
    select 
        a.RCNid, a.DEid, ta.CIncidente1, dateadd(dd, a.diasant, a.ICfecha), 
        case when abs(round(pe.RHSPEsaldiario * a.diassalario, 2)) <= abs(a.saldoreb) then round(pe.RHSPEsaldiario * a.diassalario, 2) else a.saldoreb end,
        a.ICfechasis, @Usucodigo, @Ulocalizacion, 
        0, null, 0.00, 0.00, 
        a.CFid, a.RHSPEid
    from #IncidenciasReb a, RHSaldoPagosExceso pe, RHTipoAccion ta
    where a.diassalario != 0
      and pe.RHSPEid = a.RHSPEid
      and pe.RHSPEsaldiario >= 0.01
      and ta.RHTid = pe.RHTid
 
     if @@error != 0 begin 
        raiserror 40000 'Error!, Error al insertar monto de rebajo de incapacidad!!' 
        return -1 
    end 
    /* 2.Monto a Subsidiar de la tabla RHSaldoPagosExceso */
    insert IncidenciasCalculo (
        RCNid, DEid, CIid, ICfecha, 
        ICvalor, 
        ICfechasis, Usucodigo, Ulocalizacion, 
        ICcalculo, ICbatch, ICmontoant, ICmontores, 
        CFid, RHSPEid)
    select 
        a.RCNid, a.DEid, ta.CIncidente2, dateadd(dd, a.diasant, a.ICfecha), 
        case when abs(round(pe.RHSPEsubdiario * a.diassalario, 2)) <= abs(a.saldosub) then round(pe.RHSPEsubdiario * a.diassalario, 2) else a.saldosub end,  
        a.ICfechasis, @Usucodigo, @Ulocalizacion, 
        0, null, 0.00, 0.00, 
        a.CFid, a.RHSPEid
    from #IncidenciasReb a, RHSaldoPagosExceso pe, RHTipoAccion ta
    where a.diassalario != 0
      and abs(a.saldosub) >= 0.01
      and pe.RHSPEid = a.RHSPEid
      and pe.RHSPEsubdiario >= 0.01
      and ta.RHTid = pe.RHTid
     if @@error != 0 begin 
        raiserror 40000 'Error!, Error al insertar monto a subsidiar de la Incapacidad!!' 
        return -1 
    end 
    
    if @pDEid is null begin
        /* CARGAS */
        -- Insertar las Cargas que tiene el empleado   
        insert CargasCalculo (DClinea, RCNid, DEid, CCvaloremp, CCvalorpat, CCbatch, CCvalorempant, CCvalorpatant)
        select c.DClinea, @RCNid, a.DEid, 0.00, 0.00, null, 0.00, 0.00
        from SalarioEmpleado a, CargasEmpleado b, DCargas c
        where a.RCNid = @RCNid
          and a.SEcalculado = 0
          and a.DEid = b.DEid
          and b.CEdesde <= @RChasta
          and isnull(b.CEhasta,'61000101') >= @RCdesde
          and b.DClinea = c.DClinea
          and c.Ecodigo = @Ecodigo
    
         /* DEDUCCIONES */
         insert DeduccionesCalculo (Did, RCNid, DEid, DCvalor, DCinteres, DCbatch, DCmontoant, DCcalculo)
         select a.Did, @RCNid, a.DEid, 0.00, 0.00, null, 0.00, 0
         from DeduccionesEmpleado a, SalarioEmpleado c
         where c.RCNid = @RCNid
           and c.SEcalculado = 0
           and a.Dactivo = 1
           and a.DEid = c.DEid
           and a.Dfechaini <= @RChasta
           and isnull(a.Dfechafin,'61000101') >= @RCdesde
    end
    else begin
        /* CARGAS */
        -- Insertar las Cargas que tiene el empleado   
        insert CargasCalculo (DClinea, RCNid, DEid, CCvaloremp, CCvalorpat, CCbatch, CCvalorempant, CCvalorpatant)
        select c.DClinea, @RCNid, a.DEid, 0.00, 0.00, null, 0.00, 0.00
        from SalarioEmpleado a, CargasEmpleado b, DCargas c
        where a.RCNid = @RCNid
          and a.DEid = @pDEid
          and a.SEcalculado = 0
          and a.DEid = b.DEid
          and b.CEdesde <= @RChasta
          and isnull(b.CEhasta,'61000101') >= @RCdesde
          and b.DClinea = c.DClinea
          and c.Ecodigo = @Ecodigo
    
         /* DEDUCCIONES */
         insert DeduccionesCalculo (Did, RCNid, DEid, DCvalor, DCinteres, DCbatch, DCmontoant, DCcalculo)
         select a.Did, @RCNid, a.DEid, 0.00, 0.00, null, 0.00, 0
         from DeduccionesEmpleado a, SalarioEmpleado c
         where c.RCNid = @RCNid
           and c.SEcalculado = 0
           and a.Dactivo = 1
           and c.DEid = @pDEid
           and a.DEid = c.DEid
           and a.Dfechaini <= @RChasta
           and isnull(a.Dfechafin,'61000101') >= @RCdesde
    end
    -- Borrar deducciones que no se pagan en esta Nómina, cuando hay registros
    if exists(select 1 from RHExcluirDeduccion where CPid = @RCNid) begin
          delete DeduccionesCalculo
          from #EmpleadosNomina a
          where DeduccionesCalculo.RCNid = @RCNid
            and DeduccionesCalculo.DEid = a.DEid
            and exists(select 1
                from DeduccionesEmpleado de, RHExcluirDeduccion ed
                where de.Did = DeduccionesCalculo.Did
                and ed.CPid = @RCNid
                and ed.CPid = DeduccionesCalculo.RCNid
                and de.TDid = ed.TDid)
    end
           
    -- CALCULO DE LA NOMINA
    exec @error = rh_CalculoNomina
                @Ecodigo = @Ecodigo,
                @RCNid = @RCNid,
                @Tcodigo = @Tcodigo,
                @RCdesde = @RCdesde,
                @RChasta = @RChasta,
                @IRcodigo = @IRcodigo,
                @Usucodigo = @Usucodigo,
                @Ulocalizacion  = @Ulocalizacion,
                @debug = @debug,
                @pDEid = @pDEid
                            
    if @error != 0 begin
        raiserror 40000 'Error! No se pudo Realizar el cálculo de la Nómina. Proceso Cancelado!'
        rollback tran
        return -1
    end
    if @debug='S' begin
        select "SalarioEmpleado", RCNid, DEid, SEcalculado, SEsalariobruto, SEincidencias, SEcargasempleado, SEcargaspatrono, SErenta, SEdeducciones, SEliquido, SEacumulado, SEproyectado, SEinodeduc, SEinocargas, SEinorenta
        from SalarioEmpleado 
        where RCNid = @RCNid and DEid = isnull(@pDEid, DEid)
        select 'PagosEmpleado', PElinea, DEid, RCNid, LTid, RHJid, PEhjornada, PEbatch, PEdesde, PEhasta, PEsalario, PEcantdias, PEmontores, PEmontoant, RHTid, RHPid, RHPcodigo, LTporcplaza, PEtiporeg
        from PagosEmpleado 
        where RCNid = @RCNid and DEid = isnull(@pDEid, DEid) order by DEid, PEdesde, PEhasta
        select "IncidenciasCalculo", ICid, RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, ICcalculo, ICmontores, CFid, RHSPEid
        from IncidenciasCalculo 
        where RCNid = @RCNid and DEid = isnull(@pDEid, DEid) 
        select 'CargasCalculo', DClinea, RCNid, DEid, CCvaloremp, CCvalorpat
        from CargasCalculo 
        where RCNid = @RCNid and DEid = isnull(@pDEid, DEid)
        select 'DeduccionesCalculo',RCNid, DEid, Did, DCvalor, DCinteres, DCcalculo
        from DeduccionesCalculo 
        where RCNid = @RCNid and DEid = isnull(@pDEid, DEid)
    end
if @CPtipo > 0 begin
    /* Eliminar de la relacion a todos los funcionarios que no tienen pagos */
   delete IncidenciasCalculo
   from SalarioEmpleado b
   where b.RCNid = @RCNid
      and b.DEid = coalesce (@pDEid, b.DEid)
      and b.SEincidencias = 0.00
      and b.SEliquido = 0.00
      and IncidenciasCalculo.RCNid = b.RCNid
      and IncidenciasCalculo.DEid = b.DEid
 
   delete CargasCalculo
   from SalarioEmpleado b
   where b.RCNid = @RCNid
      and b.DEid = coalesce (@pDEid, b.DEid)
      and b.SEincidencias = 0.00
      and b.SEliquido = 0.00
      and CargasCalculo.RCNid = b.RCNid
      and CargasCalculo.DEid = b.DEid
 
   delete DeduccionesCalculo
   from SalarioEmpleado b
   where b.RCNid = @RCNid
      and b.DEid = coalesce (@pDEid, b.DEid)
      and b.SEincidencias = 0.00
      and b.SEliquido = 0.00
      and DeduccionesCalculo.RCNid = b.RCNid
      and DeduccionesCalculo.DEid = b.DEid
 
   delete PagosEmpleado
   from SalarioEmpleado b
   where b.RCNid = @RCNid
      and b.DEid = coalesce (@pDEid, b.DEid)
      and b.SEincidencias = 0.00
      and b.SEliquido = 0.00
      and PagosEmpleado.RCNid = b.RCNid
      and PagosEmpleado.DEid = b.DEid
 
    delete SalarioEmpleado
     where RCNid = @RCNid
      and DEid = coalesce (@pDEid, DEid)
      and SEincidencias = 0.00
      and SEliquido = 0.00
 
end
if @debug="S"
    rollback tran
else
    commit tran
drop table #PagosEmpleado, #CalendariosEmpleado, #IncidenciasReb, #EmpleadosNomina
end
