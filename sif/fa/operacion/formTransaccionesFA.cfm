<cffunction name="fGetSNRetencion" access="remote" returnformat="json" output="false">
   <cfargument name="pSNcodigo" type="string" required="false">
	<cfquery name="rsRetencion" datasource="#Session.DSN#">
		select SNRetencion
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#ARGUMENTS.pSNcodigo#">
	</cfquery>
    <cfreturn SerializeJSON(rsRetencion,true)>
</cffunction>

<cfif isDefined('url.pSNcodigo') >
   <cfoutput>#fGetSNRetencion(url.pSNcodigo)#</cfoutput>
<cfabort/>
</cfif>

<cf_importLibs>
	<cfsavecontent variable="helpimg">
    <img src="/cfmx/sif/imagenes/Help01_T.gif" width="25" height="23" border="0"/>
</cfsavecontent>
<cfquery name="validaActividadEmpresarial" datasource="#session.dsn#">
	select Pvalor
	from Parametros
	where Pcodigo = 2200
		and Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Vlaida la existencia de registros para recuperar---->
<cfquery name="rsExistenciaRecuperacion" datasource="#session.dsn#">
		select
			count(1) as cantidad
		from FAERecuperacion e
		inner join FADRecuperacion d
		    on e.FAERid = d.FAERid
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and e.IndGenFact = 'R'
		and d.estado = 'P'
</cfquery>


<!--- SE CONSULTA EL SN POR DEFAULT --->
<cfquery name="getSocioNegPorDefault" datasource="#session.dsn#">
	SELECT SNcodigo,
       SNnumero,
       SNnombre,
       SNid
	FROM SNegocios
	WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	  AND SNcodigo = 0 <!--- 438 --->
	  AND SNinactivo = 0
</cfquery>

<!--- CONSULTA LAS DIRECCIONES DEL SN POR DEFAULT--->
<cfquery name="getSNDirDefault" datasource="#session.dsn#">
	SELECT b.id_direccion,
	       Ltrim(Rtrim(a.SNnumero)) AS SNnumero,
	      ISNULL(c.direccion1, '') + '',ISNULL(c.direccion2, '') AS texto_direccion
	FROM SNegocios a
	JOIN SNDirecciones b ON a.SNid = b.SNid
	JOIN DireccionesSIF c ON c.id_direccion = b.id_direccion
	WHERE a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	AND a.SNcodigo = 0 <!--- 438 --->
</cfquery>


<script src="/cfmx/jquery/librerias/jquery.blockUI2.66.js"></script>
	<cfif isDefined('form.LiquidacionRuteros') or isDefined('URL.LiquidacionRuteros')> <!--- Solo cuando invocamos la pantalla por un PopUp (Por Primera Vez o para modificacion) --->
		<cf_templatecss>
		<cfset form.LiquidacionRuteros = ''>
		<cfset form.NuevoL = 'Nuevo'>
		<cf_navegacion name="FALIid">
		<cf_navegacion name="ETlote">
		<cfif (isDefined('url.ETnumero') and Len(Trim(url.ETnumero)))
		   or (isDefined('form.ETnumero') and Len(Trim(form.ETnumero)))> <!--- Cambio --->
			<cfset MODO = 'CAMBIO'>
			<cf_navegacion name="ETnumero">
			<cfset MODODET = 'ALTA'>
		<cfelse>
			<cfset MODO = 'ALTA'>
		</cfif>
		<cfquery name="rsCaja" datasource="#session.dsn#">
			Select FCid
			From FALiquidacionRuteros
			Where FALIid = #FALIid#
		</cfquery>
		<cfset FCid = rsCaja.FCid>
	</cfif>
    <cfif not isdefined('form.SNnumero') and isdefined('url.SNnumero') and len(trim(url.SNnumero))NEQ 0>
		<cfset form.SNnumero = url.SNnumero>
	</cfif>
    <!---- Cuando se le da terminar, este valor es obtenido por el SQLTransaccionesFA,
	      si el check iba marcado se retorna un 1, sino 0 --->
	<cfif isdefined('url.Vuelto')>
      <cfset form.GenerarVueltoInd = url.Vuelto>
    </cfif>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0>
		<cfset modo = "CAMBIO">
		<cfset modoDet = "ALTA">
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset FCid = Trim(arreglo[1])>
		<cfset ETnumero = Trim(arreglo[2])>
		<cfif sizeArreglo EQ 3>
			<cfset DTlinea = Trim(arreglo[3])>
			<cfset modoDet = "CAMBIO">
		</cfif>
	</cfif>

	<cfif not isDefined('modoDet')>
		<cfset modoDet = "ALTA">
	</cfif>

<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif not isDefined("Form.NuevoE") and not isDefined("Form.NuevoL")>
			
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset FCid = Trim(arreglo[1])>
		<cfset ETnumero = Trim(arreglo[2])>
 		<cfif sizeArreglo EQ 3>
			<cfset DTlinea = Trim(arreglo[3])>
			<cfset modoDet = "CAMBIO">
		</cfif>
	<cfelse>
		<cfset FCid = Trim(Form.FCid)>
		<cfset ETnumero = Trim(Form.ETnumero)>
		<cfif isDefined("Form.DTlinea") and Len(Trim(Form.DTlinea)) NEQ 0>
			<cfset DTlinea = Trim(Form.DTlinea)>
		</cfif>
	</cfif>
</cfif>

<cfif not isdefined('FCid') or not isNumeric(FCid)>
	<cfset FCid = session.caja>
</cfif>

<cfset LvarNCredito = false>
<cfset LvarHayqueGenerarVuelto = false>
 <cfset LvarCookie = false>
<cfif isdefined('Cookie.CFuncional') and len(trim(#Cookie.CFuncional#)) gt 0 and  isdefined('Cookie.Socio') and len(trim(#Cookie.Socio#)) gt 0 and  isdefined('Cookie.Documento') and len(trim(#Cookie.Documento#)) gt 0>
 <cfset LvarCookie = true>
</cfif>

<!--- Cajas --->
<cfquery name="rsCajas" datasource="#Session.DSN#">
	select
        <cf_dbfunction name="to_char"	args="FCid"> as FCid,
		a.FCcodigo,
		a.FCdesc,
		<cf_dbfunction name="to_char"	args="a.Ccuenta"> as Ccuenta,
		a.Ocodigo,
		b.Odescripcion,
		c.Cformato,
		c.Cdescripcion,
        a.Aid,
        a.FCalmmodif,
        zv.id_zona,
        zv.nombre_zona
	from 	FCajas a
	    inner join  CContables c
            on a.Ccuenta = c.Ccuenta
	       and a.Ecodigo = c.Ecodigo
	     inner join  Oficinas b
           on a.Ocodigo = b.Ocodigo
	      and a.Ecodigo = b.Ecodigo
	     inner join  ZonaVenta zv
	       on zv.id_zona = b.id_zona
          and zv.Ecodigo = b.Ecodigo
	where 	a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#" >
</cfquery>

<!--- Oficinas --->
<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion
	from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Ocodigo
</cfquery>

<!--- Cuentas --->
<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char"	args="Ccuenta"> as Ccuenta, Cformato, Cdescripcion
	from CContables
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Cformato
</cfquery>

<!--- Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char"	args="Mcodigo"> as Mcodigo
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<!--- Impuestos --->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion, Iporcentaje
	from Impuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Idescripcion
</cfquery>

<!--- Transacciones (de CxC) para una caja,OJO manill@, siempre y cuando tengan un talonario asociado se muestran!! --->
<cfquery name="rsTiposTransaccion" datasource="#Session.DSN#">
	select a.CCTcodigo, b.CCTdescripcion, coalesce(<cf_dbfunction name="to_char" args="a.Tid">,'') as Tid
	from TipoTransaccionCaja a, CCTransacciones b, FAtransacciones c
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		and a.Ecodigo = b.Ecodigo
		and a.CCTcodigo = b.CCTcodigo
        and b.CCTcodigo = c.CCTcodigo
   		and a.Ecodigo = b.Ecodigo
        and b.Ecodigo = c.Ecodigo
        and exists( select 1 from Talonarios t
                where t.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                  and t.Tid = a.Tid)
</cfquery>

<!--- Talonarios --->
<cfquery name="rsTalonarios" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char"	args="Tid"> as Tid, Tdescripcion, RIserie
	from Talonarios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>


<!--- guarda el código de la lista de precios a utilizar --->
<cfset LPid = -1>
<cfset existeListaDefault = true>

<cfquery name="rsListaDefault" datasource="#Session.DSN#">
	select coalesce(LPid,0) as LPid
	from EListaPrecios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and LPdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
</cfquery>
<!--- Cliente de Contado --->
<cfquery name="rsClienteContado" datasource="#session.dsn#">
    select coalesce(<cf_dbfunction name="to_integer" args="Pvalor">,-1) as Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="435">
</cfquery>
<!--- <cfdump var="#rsClienteContado#"> --->
<!---Codigo 15836: Maneja Egresos--->
<cfquery name="rsManejaEgresos" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo =  #Session.Ecodigo#
        and Pcodigo = 15836
</cfquery>
<!--- Si no hay lista default no puede ingresar transacciones --->
<cfif rsListaDefault.RecordCount EQ 0>
	<cfset existeListaDefault = false>
<cfelse>
	<cfset LPid = rsListaDefault.LPid>
</cfif>


<!---Existen agencias?------>
<cfquery name="rsAgencias" datasource="#session.DSN#">
 select count(1) as Existen
   from SNegocios a
     inner join  RolEmpleadoSNegocios b
          on a.SNcodigo =  b.SNcodigo
		and a.Ecodigo = a.Ecodigo
    where a.Ecodigo = #Session.Ecodigo#
    and b.RESNtipoRol = 4
</cfquery>


<cfif modo NEQ "ALTA">
    <cfset LvarMontoDesc = 0>
	<!--- Consulta del encabezado de la Transacción --->
	<cfquery name="rsTransaccion" datasource="#Session.DSN#">
		select a.FCid, a.ETnumero, a.Ecodigo, a.Ocodigo, a.SNcodigo, a.Mcodigo, a.ETtc, a.CCTcodigo,  coalesce(a.id_direccion,-1) as id_direccion,a.ETesLiquidacion,
			a.Ccuenta, a.Tid, a.ETfecha, round(ETtotal+isnull(ETcomision,0),2) as ETtotal, a.ETestado, a.ETporcdes, a.ETmontodes, a.ETimpuesto,
			a.ETnumext, a.ETnombredoc, a.ETobs, coalesce(a.ETdocumento,-1) as ETdocumento, coalesce(a.ETserie,'') as ETserie,
			case when ETtotal = 0.00 then 0.00	else (ETtotal - ETmontodes) end as subtotal,
			a.ts_rversion, a.CFid, a.ETmontodes, a.ETnotaCredito, a.CDCcodigo,a.SNcodigo2,coalesce(a.ETlote,'-') as ETlote,coalesce(a.ETexterna,'N') as ETexterna,a.Rcodigo,
			((coalesce(r.Rporcentaje,0)/100) * a.ETtotal) as retencion,ETgeneraVuelto, sn.SNdireccion
			, <cf_dbfunction name="concat" args="dsif.direccion1,' ',dsif.direccion2 "> as Texto_direccion
		from ETransacciones a
			left join SNegocios sn
				on a.Sncodigo = sn.SNcodigo
				and a.Ecodigo = sn.Ecodigo
		 	left outer JOIN Retenciones r
		    	on a.Rcodigo = r.Rcodigo
				and a.Ecodigo = r.Ecodigo
			left join DireccionesSIF dsif
				on dsif.id_direccion = a.id_direccion
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
	</cfquery>

	<cfquery dbtype="query" datasource="rsTransaccion" name="rsCodigoRet">
   		select Distinct Rcodigo as CodigoRetencion from rsTransaccion
	</cfquery>

<cfif rsCodigoRet.RecordCount GT 0 AND  rsCodigoRet.CodigoRetencion[1] NEQ "">
	<cfquery name="rsTRetencion" datasource="#Session.DSN#">
		select 	Rdescripcion  as Descripcion, 	Rporcentaje  as Porcentaje
		from  Retenciones r
		where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			 and r.Rcodigo in (<cfoutput query="rsCodigoRet" > #CodigoRetencion# </cfoutput>)
	</cfquery>

</cfif>
	<cfif isdefined('rsTransaccion.ETgeneraVuelto')>
      <cfset form.GenerarVueltoInd = rsTransaccion.ETgeneraVuelto>
    </cfif>

	<cfset LvarMontoDesc = rsTransaccion.ETmontodes>

    <cfquery name="rsLineasDetalleTerminar" datasource="#Session.DSN#">
		select count(1)  as cantidadLineas
		from DTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		  and DTborrado = 0
	</cfquery>

   	<!--- Subtotal --->
	<cfquery name="rsSubTotal" datasource="#Session.DSN#">
		select sum(DTtotal) as subtotal
		from DTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		  and DTborrado = 0
	</cfquery>

     <cfquery name="rsFPagos1" datasource="#Session.DSN#">
            select
                sum(FPagoDoc) as PagoDoc
            from FPagos f
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>

    <cfquery name="rsFPagos2" datasource="#Session.DSN#">
            select Tipo
            from FPagos f
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>

    <cfif rsFPagos2.recordcount gt 0>
        <cfloop query = "rsFPagos2">
            <cfif  (rsFPagos2.Tipo eq "D" or rsFPagos2.Tipo eq "C")  and rsFPagos1.PagoDoc gt lsnumberformat(rsTransaccion.ETtotal,'9.99')>
                <cfset LvarNCredito = true>
            <cfelse>
                <cfset LvarNCredito = false>
                <cfbreak>
            </cfif>
        </cfloop>
    </cfif>
   <cfquery name="rsFPagos3" datasource="#Session.DSN#">
            select
              <!--- coalesce( sum(convert(real,FPagoDoc )),0) as FPagoDoc
             coalesce(sum(floor(round((coalesce(FPagoDoc,0)* 100),2))/100 ),0.00)    as FPagoDoc    --->
              coalesce( sum(FPagoDoc),0) as FPagoDoc
            from FPagos f
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    </cfquery>

    <!---Codigo 16039: Monto maximo p/ vuelto --->
<cfquery name="rsMontoVueltoParam" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo =  #Session.Ecodigo#
        and Pcodigo = 16039
</cfquery>

    <!---- Calculo de vuelto si existe --->
         <cfquery name="rsVuelto" datasource="#session.dsn#">
         select coalesce(sum(FPVuelto),0) as vuelto
         from FPagos
         where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
              and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
         </cfquery>
          <cfset LvarVuelto =   rsVuelto.vuelto>


       <cfif LvarVuelto gt 0 and LvarVuelto lte rsMontoVueltoParam.Pvalor><!--- Si el monto de los vueltos es menor o igual al maximo permitido, activamos vueltos--->          <cfset LvarHayqueGenerarVuelto = true>
       </cfif>

       <cfquery name="rsVueltoEnEfectivo" datasource="#session.dsn#">
         select coalesce(sum(FPVuelto),0) as vuelto
         from FPagos
         where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
         and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
         and Tipo = 'E'
        </cfquery>
        <cfif rsVueltoEnEfectivo.vuelto gt 0 >
             <cfset LvarHayqueGenerarVuelto = true>
       </cfif>

	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNid,SNcodigo, SNidentificacion, SNnombre, SNRetencion
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransaccion.SNcodigo#">
	</cfquery>

	<!--- Agencia --->
    <cfif isdefined('rsTransaccion.SNcodigo2') and len(trim(#rsTransaccion.SNcodigo2#)) gt 0>
	  <cfquery name="rsSocio2" datasource="#Session.DSN#">
		select SNid,SNcodigo,SNnumero, SNidentificacion, SNnombre
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTransaccion.SNcodigo2#">
	   </cfquery>
    </cfif>
	<!--- Nombre de la Transacción (de CxC) para una caja --->
	<cfquery name="rsTipo" datasource="#Session.DSN#">
		select a.CCTcodigo, b.CCTdescripcion, coalesce(<cf_dbfunction name="to_char" args="a.Tid">,'') as Tid, CCTvencim
		from TipoTransaccionCaja a, CCTransacciones b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransaccion.CCTcodigo#">
		  and a.Ecodigo = b.Ecodigo
		  and a.CCTcodigo = b.CCTcodigo
	</cfquery>
   	<!--- Pagos hechos a la transacción --->
	<cfquery name="rsPagos" datasource="#Session.DSN#">
		select sum(FPmontolocal) as sumFPmontolocal, sum(FPmontoori) as sumFPmontoori
		from FPagos
		where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransaccion.ETnumero#">
		  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
	</cfquery>

	<!--- Almacenes
	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select distinct a.Alm_Aid, b.Bdescripcion
		from DListaPrecios a, Almacen b
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.LPid =  <cfqueryparam cfsqltype="cf_sql_integer" value="#LPid#">
			and a.Ecodigo = b.Ecodigo
			and a.Aid = b.Aid
		order by b.Bdescripcion
	</cfquery>  --->
    <cfif rsCajas.FCalmmodif eq 1>
      <cfquery name="rsAlmacenes" datasource="#Session.DSN#">
         select b.Aid as Alm_Aid, b.Bdescripcion
            from Almacen b
            where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            order by b.Bdescripcion
       </cfquery>
    <cfelse>
       <cfquery name="rsAlmacenes" datasource="#Session.DSN#">
   		select a.Aid as Alm_Aid, a.Bdescripcion
    		from  Almacen a
	    	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	    	<cfif isdefined("rsCajas.Aid") and LEN(TRIM(#rsCajas.Aid#)) GT 0>
				and a.Aid = #rsCajas.Aid#
			</cfif>
		order by a.Bdescripcion
        </cfquery>
    </cfif>

	<!--- Departamentos --->
	<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion from Departamentos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		order by Ddescripcion
	</cfquery>
    <!----Procedencia del vendedor ------>
    <cfquery name="rsProcedenciaVendedor" datasource="#session.dsn#">
        select <cf_dbfunction name="to_integer" args="Pvalor"> as Pvalor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="15834">
    </cfquery>
   <cfif isdefined('rsProcedenciaVendedor') and rsProcedenciaVendedor.recordcount gt 0 and LEN(TRIM(rsProcedenciaVendedor.Pvalor)) GT 0 AND rsProcedenciaVendedor.Pvalor EQ 1>
         <cfquery name="rsVendedores" datasource="#Session.DSN#">
            select RESNid as FVid, a.Usucodigo,
                <cf_dbfunction name="concat" args="a.DEnombre,'  ',a.DEapellido2,'  ',a.DEapellido1"> as FVnombre
            from DatosEmpleado a, RolEmpleadoSNegocios b
            where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and b.RESNtipoRol = <cfqueryparam cfsqltype="cf_sql_tinyint" value="2">
              and a.Ecodigo = b.Ecodigo
            and  a.DEid = b.DEid
            order by <cf_dbfunction name="concat" args="a.DEnombre,'  ',a.DEapellido2,'  ',a.DEapellido1">
        </cfquery>
   <cfelse>
		<!--- Vendedores --->
        <cfquery name="rsVendedores" datasource="#Session.DSN#">
            select <cf_dbfunction name="to_char" args="FVid"> as FVid, FVnombre, Usucodigo from FVendedores
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        </cfquery>
    </cfif>
	<!--- Cuentas por Concepto --->
	<cfquery name="rsCuentasConcepto" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char" args="a.Cid"> as Cid, a.Dcodigo,
			<cf_dbfunction name="to_char" args="a.Ccuenta"> as Ccuenta,
			<cf_dbfunction name="to_char" args="a.Ccuentadesc"> as Ccuentadesc
		from CuentasConceptos a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfquery name="rsDetalles" datasource="#session.DSN#">
		select a.FCid, a.ETnumero
		from DTransacciones a, ETransacciones b
		where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.DTborrado=0
		  and a.FCid=b.FCid
		  and a.ETnumero=b.ETnumero
	</cfquery>

	<cfif modoDet NEQ "ALTA">
		<!--- Detalle de la Línea --->
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select
				<cf_dbfunction name="to_char" args="DTlinea"> as DTlinea,
				<cf_dbfunction name="to_char" args="FCid"> as FCid,
				<cf_dbfunction name="to_char" args="ETnumero"> as ETnumero,
				a.Ecodigo,
				DTtipo,
				<cf_dbfunction name="to_char" args="Aid"> as Aid,
				<cf_dbfunction name="to_char" args="Alm_Aid"> as Alm_Aid,
				<cf_dbfunction name="to_char" args="a.Ccuenta"> as Ccuenta,
				<cf_dbfunction name="to_char" args="Ccuentades"> as Ccuentades,
				<cf_dbfunction name="to_char" args="Cid"> as Cid,
				<cf_dbfunction name="to_char" args="FVid"> as FVid,
				Dcodigo,
				DTfecha,
				DTcant,
				DTpreciou,
				DTdeslinea,
                DTreclinea,
				DTtotal,
				DTborrado,
				DTdescripcion,
				DTdescalterna,
				DTlineaext,
				DTcodigoext,
				a.ts_rversion,
                CFid,
                a.Icodigo,
                i.Idescripcion,
                a.FPAEid,
                a.CFComplemento,
                coalesce(a.DTExterna,'N') as DTExterna,
                codProducto,
                codEmpresa
			from DTransacciones a
             inner join Impuestos i
                on a.Icodigo = i.Icodigo
                and a.Ecodigo = i.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DTlinea#">
			  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
			  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		</cfquery>
	</cfif>

	<!--- Cuenta los artículos y los conceptos --->
	<cfquery name="rscArticulos" datasource="#Session.DSN#">
		select count(1) as cant from Articulos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfquery name="rscConceptos" datasource="#Session.DSN#">
		select count(1) as cant from Conceptos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

</cfif>
    <cfif  modo EQ "ALTA">
     <cfquery datasource="#session.dsn#" name="direcciones">
		select b.id_direccion, Ltrim(Rtrim(a.SNnumero)) as SNnumero,
		ISNULL(c.direccion1, '') + '',ISNULL(c.direccion2, '') as texto_direccion
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo =  #Session.Ecodigo#
		   <!---  <cfif  modo EQ "ALTA" and  rsClienteContado.recordcount and isdefined("rsClienteContado.Pvalor") and rsClienteContado.Pvalor>
		     and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsClienteContado.Pvalor#">

           </cfif> --->
	</cfquery>
	<cfelse>
	   <cfquery datasource="#session.dsn#" name="direcciones">
		select b.id_direccion, a.SNnumero, <cf_dbfunction name="concat" args="c.direccion1,'/',c.direccion2 "> as texto_direccion
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo =  #Session.Ecodigo#
             and c.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransaccion.id_direccion#">
	   </cfquery>
	</cfif>
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	var pass =  false;
	var popUpWin=0;

	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	var popUpWinAC=0;

	function popUpWindowAC(URLStr, left, top, width, height)
	{
	  if(popUpWinAC)
	  {
		if(!popUpWinAC.closed) popUpWinAC.close();
	  }
	  popUpWinAC = open(URLStr, 'popUpWinAC', 'toolbar=no,location=no,directories=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	// Conlis ya sea de artículos o conceptos
	function doConlisItem() {
		if(document.form1.CFidD.value){
			if (document.form1.Item.value == "A")
				popUpWindowAC("ConlisArticulos.cfm?form=form1&id=Aid&desc=descripcion&Alm="+document.form1.Almacen.value
					+"&LPid="+document.form1.LPid.value+"&Mcodigo="+document.form1.Mcodigo.value+"&Zona="+document.form1.id_zona.value
					+"&CFid="+document.form1.CFidD.value+"&fecha="+document.form1.ETfecha.value+"&TCambio="+document.form1.ETtc.value
					+"&ETnumero="+document.form1.ETnumero.value+"&FCid="+document.form1.FCid.value,250,200,870,350);

			if (document.form1.Item.value == "S")
				popUpWindowAC("ConlisConceptos.cfm?form=form1&id=Cid&desc=descripcion&depto="+document.form1.Dcodigo.value
				+"&LPid="+document.form1.LPid.value+"&Zona="+document.form1.id_zona.value+"&CFid="+document.form1.CFidD.value
				+"&fecha="+document.form1.ETfecha.value+"&Mcodigo="+document.form1.Mcodigo.value
				+"&TCambio="+document.form1.ETtc.value+"&ETnumero="+document.form1.ETnumero.value+"&FCid="+document.form1.FCid.value,250,200,870,350);
		}
		else{
			document.form1.CFcodigoD.style.backgroundColor = '#FFFFCC';
			alert ('Debe escoger el Centro Funcional para obtener la Lista de Precios');
			return false;
		}
	}

	// validación de los campos del encabezado
	function valida(){

		<!--- var f = document.form1;
		var mensaje = '';

		if (f.SNcodigo.value == ""){
			mensaje +=  "Debe seleccionar el cliente. \n";
			//f.SNnumero.focus();
		   <!---return false;--->
		}
		if (f.CCTcodigo.value == "")		{
			mensaje +=  "Debe seleccionar el tipo de transacción. \n";
			//f.CCTcodigo.focus();
		   <!---return false;--->
		}
		if (f.FCid.value == "")		{
			mensaje +=  "Debe seleccionar la caja. \n";
			//f.FCid.focus();
			<!---return false;--->
		}
		if(f.ETnombredoc && f.CDCnombre)
		{
			if (f.ETnombredoc.value == "" && f.CDCnombre.value == "")		{
				mensaje +=  "Debe digitar el nombre del cliente o beneficiario. \n";
				//f.ETnombredoc.focus();
			<!---return false;--->
			}
		}
        if (f.CFid)
		{
			if (f.CFid.value == "")		{
				mensaje +=  "Debe seleccionar el centro funcional. \n";
				//f.CFid.focus();
			<!---return false;--->
			}
		}
        if (f.DireccionSN.length == 0){
			mensaje +=  "La dirección del socio es requerida. \n";
			//f.DireccionSN.focus();
		    <!---return false;--->
		}
		if (f.Mcodigo.value == "")		{
			mensaje +=  "Debe seleccionar la moneda. \n";
			///f.Mcodigo.focus();
	    	<!---return false;--->
		}
		var estado = f.ETtc.readonly;
		f.ETtc.readonly = false;
		if (!validaNumero(qf(f.ETtc.value)))  {
			mensaje +=  "Debe digitar el tipo de cambio. \n";
			//f.ETtc.select();
			<!---return false;--->
		}
		f.ETtc.readonly = estado;
		if (new Number(f.ETtc.value) == 0) {
			mensaje +=  "El tipo de cambio no puede ser cero. \n";
			//f.ETtc.select();
			<!---return false;--->
		}

		if (!validaNumero(qf(f.Descuento.value)))  {
			mensaje +=  "Debe digitar el descuento. \n"
			///f.Descuento.select();
			<!---return false;--->
		}
		if (f.Ccuenta.value == "")		{
			mensaje +=  "No existe cuenta para esta caja. \n";
			<!---return false;--->
		}

	   if (f.id_direccion)
		{
			if (f.id_direccion.value == "")		{
				mensaje +=  "La direccion es requerida. \n";
				//f.id_direccion.focus();
				<!---return false;--->
			}
	   }


		if(mensaje != '')
		{
		alert(  "Se presentaron los siguientes problemas: \n" + "\n" + mensaje);
		return false;
		}
		// quita las comas a los montos
		f.ETtc.readonly = false;
		f.ETtc.value = qf(f.ETtc.value);

		f.ETporcdes.value = qf(f.ETporcdes.value);
		f.ETmontodes.value = qf(f.ETmontodes.value);
		f.ETimpuesto.value = qf(f.ETimpuesto.value);

		f.ETtotal.value = qf(f.ETtotal.value);
		<cfif modo NEQ "ALTA"> return validaD(); </cfif>

		document.form1.Mcodigo.disabled = false;
		//Jose Jimenez Se esconde el boton para evitar que el usuario presione mas de 1 vez el boton y registre mas de 1 factura si el sistema se queda pegado 2/12/2015..
		document.form1.AgregarE.style.visibility = "hidden"; --->
		return true;
	}

	// validación de los campos del detalle
	function validaD() {
		<!--- var mensajeD = '';
		var f = document.form1;

		<cfif validaActividadEmpresarial.Pvalor EQ 'S'>
			if (f.CFComplemento)
			{
				if (f.CFComplemento.value == "")		{
					mensajeD +=  "La actividad empresarial es requerida. \n";
					f.CFComplemento.focus();
					<!---return false;--->
				}
		   	}
	   	</cfif>

		if (f.Aid.value == "")  {
			if (f.Cid.value == "")	{
				mensajeD +=  "Debe digitar el concepto o artículo. \n";
				<!---return false;--->
			}
			f.Aid.value = '';
		}
		if (f.Cid.value == "")  {
			if (f.Aid.value == ""){
				mensajeD +=  "Debe digitar el concepto o artículo. \n";
				<!---return false;--->
			}
			f.Cid.value = '';
		}
		if (f.DTdescripcion.value == "" || f.DTdescripcion.value == " ") {
			mensajeD +=  "Debe digitar la descripción. \n";
			f.DTdescripcion.focus()
			<!---return false;--->
		}
		<cfif modo NEQ "ALTA">
          if(f.Almacen.style.visibility == "visible")
		  {
			if (f.Almacen.value == "")
			{
				mensajeD +=  "Debe digitar el almacén. \n";
				<!---return false;--->
			}
	      }
       </cfif>

		if (!validaNumero(qf(f.DTcant.value)))  {
			mensajeD +=  "Debe digitar la cantidad. \n";
			f.DTcant.select();
			<!---return false;--->
		}
		else
			f.DTcant.value =  qf(f.DTcant.value);

		if (f.DTcant.value == '0.00')  {
			mensajeD +=  "Debe digitar la cantidad mayor que cero. \n";
			f.DTcant.select();
			<!---return false;--->
		}
		if (!validaNumero(qf(f.DTpreciou.value)))  {
			mensajeD +=  "Debe digitar el precio unitario mayor que cero. \n";
			f.DTpreciou.select();
			<!---return false;--->
		}
		else
			f.DTpreciou.value =  qf(f.DTpreciou.value);

		if (f.DTpreciou.value == '0.00')  {
			mensajeD +=  "Debe digitar el precio unitario mayor que cero. \n";
			f.DTpreciou.select();
			<!---return false;--->
		}

		<cfif isdefined('rsTransaccion.SNcodigo2') and len(trim(rsTransaccion.SNcodigo2)) and isdefined('rsSocio2') and rsSocio2.recordcount gt 0>
		 if (f.CodEmpresa.value == ""){
			mensajeD +=  "El codigo de empresa es requerido. \n";
		  }
 		 if (f.CodProducto.value == ""){
			mensajeD +=  "El codigo de producto es requerido. \n";
		  }
		</cfif>

		if(mensajeD != '')
		{
		alert(  "Se presentaron los siguientes problemas: \n" + "\n" + mensajeD);
		return false;
		}


		f.DTdeslinea.value = qf(f.DTdeslinea.value);
		f.DTtotal.value = qf(f.DTtotal.value);
		document.form1.Mcodigo.disabled = false; --->


		return true;
	}
	function disable(){
		document.form1.ModPrecio.value = 0;
		document.form1.DTdeslinea.value = 0;
		document.form1.DTrecargo.value = 0;
	}
	function suma()	{
		var f = document.form1;
		//f.DTtotal.value = f.DTtotal.defaultValue;

		if (f.DTpreciou.value=="" ) f.DTpreciou.value = "0.00"
		if( pass ==  false){
		if (f.DTdeslinea.value=="")f.DTdeslinea.value = "0.00"
		}
		if (f.DTcant.value=="" )f.DTcant.value = "0.00"
		if (f.DTrecargo.value=="" )f.DTrecargo.value = "0.00"

		if (f.DTpreciou.value=="-" ){
			f.DTpreciou.value = "0.00"
			f.DTtotal.value = "0.00"
		}
		if( pass ==  false){
		if (f.DTdeslinea.value=="-"){
			f.DTdeslinea.value = "0.00"
			f.DTtotal.value = "0.00"
		}
		}
		if (f.DTcant.value=="-" ){
			f.DTcant.value = "0.00"
			f.DTtotal.value = "0.00"
		}

		if (f.DTrecargo.value=="-" ){
			f.DTrecargo.value = "0.00"
			f.DTtotal.value = "0.00"
		}

		var cantidad = new Number(qf(f.DTcant.value))
		var precio = new Number(qf(f.DTpreciou.value))
		if(document.form1.ModPrecio.value == 1){
			if( pass ==  false){
			f.DTdeslinea.value = (f.Desc.value * f.DTcant.value);
			}
			f.DTrecargo.value = (f.rec.value * f.DTcant.value);
		}

		if( isNaN(f.DTdeslinea.value))
		f.DTdeslinea.value = 0;
    	if( isNaN(f.DTrecargo.value))
		f.DTrecargo.value = 0;

		var descuento = new Number(qf(f.DTdeslinea.value))
		var recargo = new Number(qf(f.DTrecargo.value))
		var seguir = "si"

		if(cantidad < 0){
			f.DTcant.value="0.00"
			seguir = "no"
		}

		if(precio < 0){
			f.DTpreciou.value="0.00"
			seguir = "no"
		}

		if(descuento < 0){
			f.DTdeslinea.value="0.00"
			seguir = "no"
		}

		if(recargo < 0){
			f.DTrecargo.value="0.00"
			seguir = "no"
		}

		if(descuento > cantidad*precio){
			f.DTdeslinea.value="0.00"
			if(recargo > cantidad*precio){
				f.DTrecargo.value="0.00"
				f.DTtotal.value = cantidad * precio
			}
			else{
				f.DTtotal.value = (cantidad * precio) + recargo
			}
		}
		else if(recargo > cantidad*precio){
			f.DTrecargo.value="0.00"
			f.DTtotal.value = (cantidad * precio) - descuento
		}
		else {
			f.DTtotal.value = ((cantidad * precio) - descuento) + recargo
			f.DTtotal.value = fm(f.DTtotal.value,2)
		}

	}

	function suma2(){
	     pass =  true;
		var f = document.form1;
		var TotalU = new Number(qf(f.DTpreciou.value));
		var Cant = new Number(qf(f.DTcant.value));
		var Descue= new Number(qf(f.DTdeslinea.value));
		var recargo = new Number(qf(f.DTrecargo.value));

		if(parseInt(Descue) > parseInt(TotalU))
		{
		  	f.DTdeslinea.value ="0.00";
		}
		else
		{
           var result  = (Cant * TotalU);

		   result  = (result - Descue);

		    result  = (result + recargo);


		   		  f.DTtotal.value = fm(result,2)
		}

	}

	function limpiarDetalle() {
		var f = document.form1;
		f.descripcion.value="";
		f.DTdescalterna.value="";
		f.DTdescripcion.value="";
		f.Aid.value="";
		f.Cid.value="";
	}

function funcAsignar(){
    var Ecodigo = <cfoutput>#session.Ecodigo#</cfoutput>;
	var SNcodigo = $("#SNcodigo").val();
	funcDireccionesSocio(Ecodigo)
}
function funcDireccionesSocio(Ecodigo){
  //debugger;
     var Ecodigo = <cfoutput>#session.Ecodigo#</cfoutput>;
  	 var SNcodigo = $("#SNcodigo").val();
  	 //alert(SNcodigo);
  	 if(SNcodigo!=''){
	  $("#id_direccion").empty();
     var dataP = {
			method: "DireccionesSocio",
		   Ecodigo:  Ecodigo,
		  SNcodigo:  SNcodigo
		}

		try {
			$.ajax ({
				type: "get",
				url: "/cfmx/sif/fa/operacion/FacturacionMetodos.cfc",
				data: dataP,
				dataType: "json",
				success: function( objResponse ){
					var lista = objResponse.DATA;
				  	$("#id_direccion").empty();

					for(i= 0; i < lista.length;	i++){
					   $("#id_direccion").append( $('<option>', {
						   text: lista[i][1],
						   value: lista[i][0]
						   }));
					   $( "#id_direccion option:selected" ).text();
    				}
					<!---
					var x = document.getElementById("id_direccion");
					while(x.firstChild != null){ x.removeChild(x.firstChild); }
					for(i= 0; i < lista.length;	i++) {
						var v = lista[i][1];
						v = v.replaceAll('\r',' ').replaceAll('\n',' ');
						if(v.trim() != ''){
							var option = document.createElement("option");
							option.text = v;
							option.value = lista[i][0];
							x.add(option);
						}
					}
					--->
					},
				error:  function( objRequest, strError ){
					alert('ERROR'+objRequest + ' - ' + strError);
					console.log(objRequest);
					console.log(strError);
					}
			});
		} catch(ss){
		 alert('FALLO Inesperado');
		 console.log(ss);
		}
  	 	}

}

	// cambia según el item que se escogió
function cambiarDetalle(){
		var f = document.form1;
		if(f.Item.value=="A"){
			f.DetalleItem.value="Articulo: ";
			f.DetalleItem.style.visibility="visible";
			f.descripcion.style.visibility="visible";
			document.getElementById("imgArticulo").style.visibility = "visible";
			<cfif modo NEQ "ALTA">
			f.Almacen.style.visibility = "visible";
			document.getElementById("AlmacenLabel").style.visibility = "visible";
			</cfif>
		}

		if(f.Item.value=="S"){
			f.DetalleItem.value="Concepto: ";
			f.DetalleItem.style.visibility="visible";
			f.descripcion.style.visibility="visible";
			document.getElementById("imgArticulo").style.visibility = "visible";
			<cfif modo NEQ "ALTA">
			f.Almacen.style.visibility = "hidden";
			document.getElementById("AlmacenLabel").style.visibility = "hidden";
			</cfif>
		}

	}

	// limpia los campos según cambia el combo de almacenes
	function limpiarAxCombo() {
       var f = document.form1;
	   f.Aid.value = "";
	   f.descripcion.value = "";
	   f.DTtipo.value = "S";
	   f.DTdescripcion.value = f.descripcion.value;
	}

	function Lista() {
		location.href = '<cfoutput>#LvarPaginaIni#</cfoutput>';
	}

	function poneItem() {
        var f = document.form1;
		if (f.Item.value == "A") f.DetalleItem.value = "Artículo";
		if (f.Item.value == "S") f.DetalleItem.value = "Concepto";
	}

	// En un hidden manda si se cambió o no los datos del encabezado, con el fin de saber si se debe actualizar el mismo
	function EncabezadoCambio() {
		var f = document.form1;
		f.CambioEncabezado.value = '0';

		if (f.Mcodigo.defaultValue != f.Mcodigo.value)  {
			f.CambioEncabezado.value = '1';
			return;
		}
		var estado = f.ETtc.readonly;
		f.ETtc.readonly = false;
		if (f.ETtc.defaultValue != f.ETtc.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		f.ETtc.readonly = estado;
		if (f.ETnombredoc.defaultValue != f.ETnombredoc.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.ETobs.defaultValue != f.ETobs.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.SNcodigo.defaultValue != f.SNcodigo.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.Icodigo.defaultValue != f.Icodigo.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.ETimpuesto.defaultValue != f.ETimpuesto.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.CCTcodigo.defaultValue != f.CCTcodigo.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		if (f.Descuento.defaultValue != f.Descuento.value) {
			f.CambioEncabezado.value = '1';
			return;
		}
		return false;
	}

	// Trae los datos asociados a la caja
	function TraerDatosCaja(caja) {
		var f = document.form1;
		 <cfloop query="rsCajas">
		   if (caja == "<cfoutput>#rsCajas.FCid#</cfoutput>") {
				f.Ccuenta.value="<cfoutput>#rsCajas.Ccuenta#</cfoutput>";
				f.Ocodigo.value="<cfoutput>#rsCajas.Ocodigo#</cfoutput>";
		  }
		 </cfloop>
	}

	// Sugiere el nombre del cliente en el campo del nombre del documento
	function AsignarNombre() {
		var f = document.form1;
		f.ETnombredoc.value = '';
		f.ETnombredoc.value = f.SNnombre.value;
	}

  function ObtenerAplicaRetencion(){
	var f = document.form1;
    var resultado;
    $.ajax('/cfmx/sif/fa/operacion/formTransaccionesFA.cfm?method=fGetSNRetencion&pSNcodigo='+f.SNcodigo.value+'',
      { "type": "get",
        "success": function(result) {
          resultado=jQuery.parseJSON( result );
        },       "error": function(result) {
        console.error("Este callback maneja los errores", result);
        },
        "async": false
      }
    );
	if(resultado.DATA.SNRETENCION[0]){
	  $("#aplicaRet").show();
	} else{
	  $("#aplicaRet").hide();

	}

}


	// Sugiere el nombre del cliente en el campo del nombre del documento
	function funcSNnumero() {
		var f = document.form1;
		<cfoutput>
			<cfif isdefined("rsClienteContado.Pvalor")>
				if(f.SNcodigo.value == #iif(rsClienteContado.Pvalor neq "", rsClienteContado.Pvalor, 0)#){
					document.getElementById('nombreDoc').style.display  = 'none';
					document.getElementById('clienteDet').style.display = '';
					document.getElementById('docLabel').innerHTML = 'Cliente Detallista:';
					f.ETnombredoc.value = '';
				}
				else{
					document.getElementById('nombreDoc').style.display  = '';
					document.getElementById('clienteDet').style.display = 'none';
					document.getElementById('docLabel').innerHTML = '';
					document.getElementById('docLabel').innerHTML = 'Nombre en el Documento:';
					f.ETnombredoc.value = '';
					f.ETnombredoc.value = f.SNnombre.value;
					 ObtenerAplicaRetencion();

				}

			<cfelse>
				f.ETnombredoc.value = '';
				f.ETnombredoc.value = f.SNnombre.value;
			</cfif>
		</cfoutput>
	}

//ALH---Función que obtiene la dirección de acuerdo al SNnumero del conlis Cliente
function fncCambioDir(){
			  var sn = document.getElementById('SNnumero').value.trim();
			  var ob = document.form1.id_direccion;
		  <cfwddx action="cfml2js" input="#direcciones#" topLevelVariable="jsdirecciones">
		  var nRows = jsdirecciones.getRowCount();
		  if (nRows > 0) {
		    ob.options.length = 1;
		    for (row = 0; row < nRows; ++row) {
		      if (jsdirecciones.getField(row, "SNnumero") === sn){
		        var opt = document.createElement("OPTION");
		        opt.value = jsdirecciones.getField(row, "id_direccion");
		        opt.text = jsdirecciones.getField(row, "texto_direccion");
		        ob.options.add(opt);
		      }
		    }
		  }
		}

	// Trae el número de Talonario de la transacción seleccionada
	function TraerTalonario(Tid) {
		var f = document.form1;
		 <cfloop query="rsTalonarios">
		     if (Tid == "<cfoutput>#rsTalonarios.Tid#</cfoutput>") {
				f.ETserie.value="<cfoutput>#rsTalonarios.RIserie#</cfoutput>";
		  }
		 </cfloop>
	}

	// prepara algunos datos al hacer el post
	function prepararDatos() {
		var f = document.form1;
		f.DTtipo.value = f.Item.value;
		var estado = f.ETtc.readonly;
		f.ETtc.readonly = false;
		if (valida()) {
			f.CambioEncabezado.value = '0';
			return true;
		} else {
			f.ETtc.readonly = estado;
			f.ETimpuesto.value = fm(f.ETimpuesto.value,2);
			f.ETtotal.value = fm(f.ETtotal.value,2);
			return false;
		}
	}

	function actualizarEncabezado (){
		EncabezadoCambio();
			return true;
	}

	function Postear(){
		if (confirm('¿Desea terminar de procesar este documento?')) {
			document.form1.ETtc.readonly = false;
			return true;
		}
		return false;
	}

	function popUpWindowResizable(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	 /* popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');*/

	var win = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	var timer = setInterval(function() {
		if(win.closed) {
			clearInterval(timer);
			//window.location.reload();
			document.form1.action="<cfoutput>#LvarEditPagina#</cfoutput>";
			document.form1.submit();
		}
	}, 1000);

	}

	function fn_pagar() {
    	var x = document.getElementById("tbLineas").rows[1].cells;
    	if( x[1] === undefined){
		 alert('No se cuenta con lineas de detalle al momento. Favor agregar alguna para poder realizar pagos');
		}
		else{

			popUpWindowResizable("<cfoutput>#LvarPagosPagina#</cfoutput>?form=form1&FCid="+document.form1.FCid.value+"&ETnumero="+document.form1.ETnumero.value,80,120,900,500);
		}
	}

 	function fn_Comisiones() {
		<!---popUpWindowResizable("Comisiones.cfm?PcodigoE="+f.Pcodigo.obj.value+"&CCTcodigoE="+f.CCTcodigo.value+"&PtipoSN="+f.PtipoSN.obj.value+"&SNcodigoD="+f.SNcodigo.obj.value+"&Mcodigo="+f.Mcodigo.obj.value,80,120,900,500);--->
		popUpWindowResizable("Comisiones.cfm?FA=contado&ETnumero="+f.ETnumero.value+"&FCid="+f.FCid.value+"&CCTcodigoE="+f.CCTcodigo.value+"&Mcodigo="+f.Mcodigo.value,380,120,600,300);
	}



	// Valida si la transacción (factura) ya está pagada (suma de Pagos >= total de la transacción (factura))
	// Nota: la suma de los pagos es en moneda local, por lo que hay que dividirlo entre el tc de la transacción
	function Pagada() {
		var f = document.form1;
		var suma = new Number(qf(f.sumaPagos.value));
		var total = new Number(qf(f.ETtotal.value));
		var tc = new Number(qf(f.ETtc.value));

		if ((suma/tc) >= total)
			return true;
		else
			return false;
	}
		function doConlisCFuncional() {
		var params ="";
		params = "?form=form1&id=CFidD&name=CFcodigoD&desc=CFdescripcionD";
		popUpWindow("/cfmx/sif/fa/operacion/ConlisCFuncional.cfm"+params,250,200,650,400);
	}

	//Obtiene la descripción con base al código

	  function TraerTransaccion(transaccion) {
		var f = document.form1;
		 <cfloop query="rsTiposTransaccion">
		   if (transaccion == "<cfoutput>#rsTiposTransaccion.CCTcodigo#</cfoutput>") {
				f.Tid.value = "<cfoutput>#rsTiposTransaccion.Tid#</cfoutput>";
		  }
		 </cfloop>
	}

	<!---$('#SNnumero').keyup(alert());
	$('#SNnumero').blur(alert());
	$('#SNnumero').focus(alert());
	--->

	<cfwddx action="cfml2js" input="#direcciones#" 	 topLevelVariable="direcciones">
	nRows = direcciones.getRowCount();
	function fn_direcciones(value)
	{
		//debugger;
		//value = $('#SNnumero').val();
		if(value != ''){
			campoDir = document.getElementById("DireccionSN");
			count = campoDir.options.length;
			while (count != 0) {
			   campoDir.remove(count-1);
			   count = campoDir.options.length;
			}
			if (nRows > 0) {
				i = 1;
				for (row = 0; row < nRows; ++row){
					var snDir = direcciones.getField(row, "SNnumero");
					if (snDir.indexOf(value) == 0 || value.indexOf(snDir) == 0){
						campoDir.options[i++] = new Option(direcciones.getField(row, "texto_direccion"),direcciones.getField(row, "id_direccion"));
					}
				}
			}
		}
	}

	<!--- unicamente si es de tipo externa y esta en modificacion --->
	<cfif modo EQ 'CAMBIO' and rsTransaccion.ETexterna EQ 'S'>
		//funcion para modificar retencion de forma manual
		function modificarRetencionManual(e){
			e.preventDefault();
			<cfoutput>
				var _ETnumero = #rsTransaccion.ETnumero#;
				var _FCid = #rsTransaccion.FCid#;
			</cfoutput>
			var _rcodigo = $('#RcodigoManual').val();
			var dataP = {
				method: 'ModificarRetencionManual',
				ETnumero: _ETnumero,
				FCid: _FCid,
				rcodigo: _rcodigo
			};
			try {
				$.ajax ({
					type: "get",
					url: "/cfmx/sif/fa/operacion/SQLTransaccionesFAAjax.cfc",
					data: dataP,
					dataType: "json",
					success: function( objResponse ){
						if(objResponse.SUCCESS) {
							_refrescarDespuesModificarRetencionManual();
						} else {
							alert('ERROR:'+objResponse.MENSAJE + ' - ' + objResponse.MENSAJEERROR);
							_refrescarDespuesModificarRetencionManual();
						}
						},
					error:  function( objRequest, strError ){
						alert('ERROR'+objResponse.MENSAJE + ' - ' + objResponse.MENSAJEERROR);
						_refrescarDespuesModificarRetencionManual();
					}
				});
			} catch(ss){
			 	alert('Ocurrió un error inesperado' + ' - ' + objResponse.MENSAJEERROR);
			 	_refrescarDespuesModificarRetencionManual();
			}
		}

		function _refrescarDespuesModificarRetencionManual(){
			PopUpCerrar2();
			document.form1.action="TransaccionesFA.cfm";
			document.form1.submit();
		}
	</cfif>

</script>
<style type="text/css">
	#btnModificarRetencion{
		box-shadow: 0px 0px 10px rgb(243, 141, 11)
	}
	#btnModificarRetencion:hover{
		color:blue;
	}
	#Mcodigo {
		width: 150px;
	}
	.noBorder{
		border:0 !important;
	}
	select {
		max-width: 300px;
	}
	.panelIzquierdo{
		width:80%;
	}

	.panelIzquierdo td p{
		margin:0;
	}

	.panelDerecho{
		width: 20%;
		border-left: 1px solid #0079C1;
		border-bottom: 1px solid #0079C1;
		padding-left: 5px;
		padding-right: 5px;
		vertical-align: top;
	}

	.panelDerecho input{
		/*font-size: 16px;
		width: 85%;*/
	}

	.total {
		font-size: 18px;
		font-weight: bold;
		font-family: Arial;
		font-style: normal!important;
	}
	.OtrosTotales {
		font-size: 16px;
		font-weight: bold;
		font-family: Arial;
	}
	.OtrosTotales label{
		font-style: normal;
	}
	.TextoNegrita {
		font-weight: bold;
		border-color:transparent;
	}
	.style1 {color: #CC0000}
	.colorAzul {color: #000099;}
	.etiqueta {
		color:#555;
		font-family: Arial;
		font-size: 13px;
		font-weight: bold;
		font-style: normal;
		text-decoration: none;
		margin: 0;
		margin-right: 2px;
		padding: 0;
	}
	.inputMonto{
		width: 100px;
	}
	#tablaContenedora tr td{
		vertical-align: bottom;
	}
	#tablaContenedora select{
		width:200px;
	}
	#listaAgenciasCol input[type="text"]{
		width: 152px;
	}
	#myModal1 .modal-body{
		padding:5px;
		padding-right: 10px;
	}
	#myModal1 .modal-footer{
		padding:3px;
		padding-right: 10px
		padding-bottom:5px;
	}
	#myModal1 .modal-header{
		padding:10px;
		text-align: right;
		/* http://www.colorzilla.com/gradient-editor */
		<cfif isDefined('modDet') and modoDet EQ 'ALTA'>
			background: #b4e391; /* Old browsers */
			/* IE9 SVG, needs conditional override of 'filter' to 'none' */
			background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2I0ZTM5MSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjUwJSIgc3RvcC1jb2xvcj0iIzYxYzQxOSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNiNGUzOTEiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);
			background: -moz-linear-gradient(top,  #b4e391 0%, #61c419 50%, #b4e391 100%); /* FF3.6+ */
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#b4e391), color-stop(50%,#61c419), color-stop(100%,#b4e391)); /* Chrome,Safari4+ */
			background: -webkit-linear-gradient(top,  #b4e391 0%,#61c419 50%,#b4e391 100%); /* Chrome10+,Safari5.1+ */
			background: -o-linear-gradient(top,  #b4e391 0%,#61c419 50%,#b4e391 100%); /* Opera 11.10+ */
			background: -ms-linear-gradient(top,  #b4e391 0%,#61c419 50%,#b4e391 100%); /* IE10+ */
			background: linear-gradient(to bottom,  #b4e391 0%,#61c419 50%,#b4e391 100%); /* W3C */
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#b4e391', endColorstr='#b4e391',GradientType=0 ); /* IE6-8 */
		<cfelse>
			background: #d2dfed;
			/* Old browsers */
			/* IE9 SVG, needs conditional override of 'filter' to 'none' */
			background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iI2QyZGZlZCIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjI2JSIgc3RvcC1jb2xvcj0iI2M4ZDdlYiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjkwJSIgc3RvcC1jb2xvcj0iIzk5YjVkYiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9Ijk2JSIgc3RvcC1jb2xvcj0iI2JhZDBlZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9Ijk5JSIgc3RvcC1jb2xvcj0iI2JlZDBlYSIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9Ijk5JSIgc3RvcC1jb2xvcj0iI2E2YzBlMyIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiNhZmM3ZTgiIHN0b3Atb3BhY2l0eT0iMSIvPgogICAgPHN0b3Agb2Zmc2V0PSIxMDAlIiBzdG9wLWNvbG9yPSIjNzk5YmM4IiBzdG9wLW9wYWNpdHk9IjEiLz4KICA8L2xpbmVhckdyYWRpZW50PgogIDxyZWN0IHg9IjAiIHk9IjAiIHdpZHRoPSIxIiBoZWlnaHQ9IjEiIGZpbGw9InVybCgjZ3JhZC11Y2dnLWdlbmVyYXRlZCkiIC8+Cjwvc3ZnPg==);
			background: -moz-linear-gradient(top, #d2dfed 0%, #c8d7eb 26%, #99b5db 90%, #bad0ef 96%, #bed0ea 99%, #a6c0e3 99%, #afc7e8 100%, #799bc8 100%); /* FF3.6+ */
			background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#d2dfed), color-stop(26%,#c8d7eb), color-stop(90%,#99b5db), color-stop(96%,#bad0ef), color-stop(99%,#bed0ea), color-stop(99%,#a6c0e3), color-stop(100%,#afc7e8), color-stop(100%,#799bc8)); /* Chrome,Safari4+ */
			background: -webkit-linear-gradient(top, #d2dfed 0%,#c8d7eb 26%,#99b5db 90%,#bad0ef 96%,#bed0ea 99%,#a6c0e3 99%,#afc7e8 100%,#799bc8 100%); /* Chrome10+,Safari5.1+ */
			background: -o-linear-gradient(top, #d2dfed 0%,#c8d7eb 26%,#99b5db 90%,#bad0ef 96%,#bed0ea 99%,#a6c0e3 99%,#afc7e8 100%,#799bc8 100%); /* Opera 11.10+ */
			background: -ms-linear-gradient(top, #d2dfed 0%,#c8d7eb 26%,#99b5db 90%,#bad0ef 96%,#bed0ea 99%,#a6c0e3 99%,#afc7e8 100%,#799bc8 100%); /* IE10+ */
			background: linear-gradient(to bottom, #d2dfed 0%,#c8d7eb 26%,#99b5db 90%,#bad0ef 96%,#bed0ea 99%,#a6c0e3 99%,#afc7e8 100%,#799bc8 100%); /* W3C */
			filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#d2dfed', endColorstr='#799bc8',GradientType=0 ); /* IE6-8 */
		</cfif>
	}
</style>

<form name="form1" action="<cfoutput>#LvarSQLPagina#</cfoutput>" method="post" onsubmit="bloquearPantalla();">
	<input name="Modo" type="hidden" value="<cfoutput>#Modo#</cfoutput>">
	<input name="ModoDet" type="hidden" value="<cfoutput>#ModoDet#</cfoutput>">
	
	<cfset PintaEncabezado()>

<!---------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
									LINEA LINEA LINEA
								DETALLE DE LA TRANSACCION 2
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------------->
	<cfif modo NEQ "ALTA">
		<cfset PintaCamposModDetalle()>
	</cfif>


<cfif modo NEQ "ALTA">
    <table width="90%" align="center" border="0" cellpadding="0" cellspacing="0">

      <tr>
        <td colspan="12"><div align="center">
            <input id="BorrarE" name="BorrarE" tabindex="3" type="submit" value="Anular Documento" class="btnEliminar" onclick="javascript:if (confirm('¿Desea anular este documento?')) return true; else return false;">
            <cfif rsTransaccion.ETestado NEQ "T">

				<input type="button" tabindex="3" name="ListaE" class="btnAnterior" value="Regresar" onClick="javascript:Lista();">
				<cfif rsTransaccion.ETtotal gt LvarTotalPagado <!--- and (LvarTotalPagado lte  0 or rsTipo.CCTvencim EQ "-1") --->>
					<input id="Pagar" type="button" tabindex="3" name="Pagos" value="Pagar" class="btnAplicar" onClick="javascript:fn_pagar();">
				</cfif>

			    <!--- <cfif LvarNCredito eq true or LvarHayqueGenerarVuelto eq true >
                <!---   <cfif rsTransaccion.ETnotaCredito EQ 1 or  rsTransaccion.ETgeneraVuelto EQ 1> --->
                	<input id="idTerminar" type="submit" class="btnAPlicar" tabindex="3" style="visibility: hidden;" name="Terminar" value="Terminar" onClick="javascript: return Postear();">
                 <!---  </cfif>---> --->
				<cfif (LvarTotalPagado neq  0  and LvarTotalPagado gte lsnumberformat(rsTransaccion.ETtotal - rsTransaccion.retencion <!--- -rsComision.ComisionTotal --->,'9.99'))>
                   <input id="idTerminar" type="submit" class="btnAplicar" tabindex="3" style="visibility: 'hidden';" name="Terminar" value="Terminar" onClick="javascript: return Postear();">
				<cfelseif LvarTotalPagado neq  0 and LvarTotalPagado gte lsnumberformat(rsTransaccion.ETtotal - rsTransaccion.retencion-rsComision.ComisionTotal,'9.99') and rsLineasDetalleTerminar.cantidadLineas gt 0  and rsTipo.CCTvencim eq -1 and LvarTotalPagado gt 0 >
                   <input id="idTerminar" type="submit" class="btnAplicar" tabindex="3" style="visibility: 'hidden';" name="Terminar" value="Terminar" onClick="javascript: return Postear();">
                </cfif>

			<cfelse>
                <input id="idReabrir" class="btnNormal" type="submit" tabindex="3"  name="Reabrir" value="Re Abrir" onClick="">
				<input type="button" tabindex="3" class="btnAnterior" name="ListaE" value="Regresar" onClick="javascript:Lista();">
                <input id="idAplicar" type="submit" tabindex="3" name="Aplicar" class="btnAplicar" value="Aplicar" onclick="javascript:if (confirm('¿Desea aplicar este documento?')) return true; else return false;" />
			</cfif>

			<!--- Boton para recuperar lineas --->
			<cfif rsExistenciaRecuperacion.cantidad gt 0>
			<input name="btnRecuperar" id="btnRecuperarLinea" type="button" class="btnNormal" value="Recuperar Línea" onclick="MostrarRecuperar(event);"/>
			</cfif>

			<cfif rsManejaEgresos.Pvalor eq 1 and not isdefined('rsSocio2')>
            	<input name="Comisiones" 	type="button" 	value="Comisiones" class="btnNormal" tabindex="3" onClick="javascript:fn_Comisiones();">
            </cfif>

            <!--- Boton para modificar el emcabezado. --->
            <input name="CambiarD" tabindex="3" type="submit" class="btnGuardar" value="Modificar"
			            			 	   onClick="javascript: return actualizarEncabezado();">

            <!--- Botones para agregar lineas --->
            <div style="float:right">
			<!--- aqui  PintaListaDetalles --->
				<div id="divNuevoDet">
					<input name="NuevoDet" class="btnNuevo" tabindex="3" type="submit" value="Nueva Línea">
				</div>
			</div>
          </div></td>
      </tr>

      <iframe name="precios" id="precios" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
      <iframe name="nc"      id="nc"      marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
    </table>

	<script language="JavaScript1.2" type="text/javascript">
		// Trae la cuenta asociada al concepto
		function TraerCuentaConcepto(concepto,depto) {
			var f = document.form1;
			 <cfloop query="rsCuentasConcepto">
			   if (depto == "<cfoutput>#rsCuentasConcepto.Dcodigo#</cfoutput>"
			   && concepto == "<cfoutput>#rsCuentasConcepto.Cid#</cfoutput>" ) {
					f.CcuentaDet.value="<cfoutput>#rsCuentasConcepto.Ccuenta#</cfoutput>";
					f.CcuentadesDet.value="<cfoutput>#rsCuentasConcepto.Ccuentadesc#</cfoutput>";
			  }
			 </cfloop>

		}
	function bloquearPantalla()
	{
		$(document).ready(function() {

        $.blockUI({
            fadeIn: 1000,
        });
		$('.blockMsg h1').html('Procesando...');

		});
	}
	</script>

</cfif>
</form>


    <!---------------------------------------   LINEAS DETALLES DE LA FACTURA ------------------------------>
    <!---------------------------------------   LINEAS DETALLES DE LA FACTURA ------------------------------>
    <!---------------------------------------   LINEAS DETALLES DE LA FACTURA ------------------------------>

	<cfset PintaListaDetalles()>

<script type="text/javascript">
	<cfif isDefined('form.LiquidacionRuteros')>
		function Editar(data) {
			var f = document.form2;
			if (data!="") {
				f.action='formTransaccionesFA.cfm';
				f.datos.value=data;
				f.submit();
			}
			return false;
		}
	<cfelse>
		function Editar(data) {
			var f = document.form2;
			if (data!="") {
				f.action='TransaccionesFA.cfm';
				f.datos.value=data;
				f.submit();
			}
			return false;
		}
	</cfif>
	
	<cfif moduloOrigen eq "CRC">
		function EliminarLineaCRC(data) {
			var f = document.form2;
			if (data!="") {
				f.action='<cfoutput>#LvarSQLPagina#</cfoutput>';
				f.datos.value=data;
				f.FAction.value="EliminarLineaCRC"
				f.submit();
			}
			return false;
		}
	</cfif>

</script>


<iframe name="ifrTipoPago" id="ifrTipoPago" marginheight="0" marginwidth="10" frameborder="0" height="0" width="0" scrolling="auto"></iframe>
<script language="JavaScript1.2">
	$(document).ready(function(){
		//debugger;
		$('#myModal1 .modal-footer button').addClass('btn-danger');
		$("#SNnumero").on("blur",funcDireccionesSocio);
	});
	function asignaTipoPago(transaccion)
	{
		<!---var param= 'tran='+transaccion;
		document.getElementById('ifrTipoPago').src = '/cfmx/sif/fa/operacion/tipoPago.cfm?'+param;--->
	}
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
	function asignaTC() {

		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
			formatCurrency(document.form1.TC,2);
			document.form1.ETtc.readonly = true;
		}
		else
			document.form1.ETtc.readonly = false;
		var estado = document.form1.ETtc.readonly;
		document.form1.ETtc.readonly = false;
		document.form1.ETtc.value = fm(document.form1.TC.value,2);
		document.form1.ETtc.readonly = estado;

	}

	// Valida y calcula el descuento ya sea por el monto o por el porcentaje
	function calculaDescuento() {
		var f = document.form1;
		var desc = new Number(qf(f.Descuento.value));
		var total = new Number(qf(f.ETtotal.value));

		if (f.chkPorcentaje.checked) {
			if (desc > 100) {
				alert('Debe digitar un porcentaje entre 0 y 100%');
				f.Descuento.select();
				return false;
			}
			else {
				f.ETporcdes.value = desc;
				f.ETmontodes.value = (total * desc) / 100;
				return true;
			}
		}
		else {
			f.ETmontodes.value = desc;
			if (total != 0)
				f.ETporcdes.value = (desc * 100) / total;
			else
				f.ETporcdes.value = 0.00;
			return true;
		}
		return true;
	}

	// Inicializa el Tipo de cambio
	function validatcLOAD()
	{
	  <cfif modo EQ "ALTA">
			if (document.form1.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")	{
				document.form1.ETtc.value = "1.0000";
				document.form1.ETtc.readonly = true;
			}
			else {
				document.form1.Mcodigo.value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>";
				document.form1.ETtc.value = "1.0000";
				document.form1.ETtc.readonly = true;
			}
	   <cfelse>
			if (document.form1.Mcodigo.value=="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>")
				document.form1.ETtc.readonly = true;
			else
				document.form1.ETtc.readonly = false;
	   </cfif>

	}
		function CreaEncabezado()
	{
	 document.form1.CFid.value= document.form1.CokCFid.value;
 	 document.form1.CFcodigo.value= document.form1.CokCFcodigo.value;
	 document.form1.CFdescripcion.value= document.form1.CokCFdescripcion.value;
	 document.form1.SNcodigo.value= document.form1.CokSNcodigo.value;
	 document.form1.SNnumero.value= document.form1.CokSNnumero.value;
	 document.form1.SNnombre.value= document.form1.CokSNnombre.value;
	 document.form1.ETnombredoc.value= document.form1.CokDocumento.value;

	   document.form1.submit();

	}
	function ListaP(){
		if(document.form1.ModPrecio.value == 1){
			centro = document.form1.CFidD.value;
			iZona  = document.form1.id_zona.value;
			moneda = document.form1.Mcodigo.value;
			LPid   = document.form1.LPid.value;
			var Aid = 0;
			var Cid;
			if(document.form1.Item.value == 'A'){
				Aid = document.form1.Aid.value;
			}
			else{
				Cid = document.form1.Cid.value;
			}
			fecha  = document.form1.ETfecha.value;
			document.getElementById('precios').src = 'ListaPrecio.cfm?CFid='+centro+'&zona='+iZona+'&Aid='+Aid+'&fecha='+fecha+'&Cid='+Cid+'&moneda='+moneda
			+'&TCambio='+document.form1.ETtc.value+'&LPid='+LPid;
		}
	}

	//Muestra el panel de recuperacion, de una linea
	function MostrarRecuperar(e){
		e.preventDefault();
		lineasSeleccionadas = "";
		$('#pnlRecuperar').show('slow');
	}
</script>

<script language="JavaScript1.2" type="text/javascript">
	var f = document.form1;
	<cfif modo NEQ "ALTA">
     f.Almacen.disabled = false;
    </cfif>
	f.LPid.value = '<cfoutput>#LPid#</cfoutput>';
	validatcLOAD();
	<cfif modo NEQ "ALTA">
		asignaTC();
	<cfelse>
		var estado = f.ETtc.readonly;
		f.ETtc.readonly = false;
		f.ETtc.value = f.TC.value;
		f.ETtc.readonly = estado;
	</cfif>

	<cfif modo NEQ "ALTA">
		poneItem();
		cambiarDetalle();
		<cfif rsTransaccion.ETestado NEQ "T">
			<cfif rsTipo.CCTvencim EQ -1>
				if (Pagada()) {
					try{<!---document.getElementById("idTerminar").style.visibility = 'visible';--->}catch(e){}
				}
			<cfelseif rsTipo.CCTvencim NEQ -1 >
				try{document.getElementById("idTerminar").style.visibility = 'visible';}catch(e){}
			<cfelse>
				try{document.getElementById("idTerminar").style.visibility = 'hidden';}catch(e){}
			</cfif>
		</cfif>
	<cfelse>
		<!--- f.SNnumero.focus(); --->
	</cfif>
	<!--- <cfif rsTransaccion.ETestado neq 'T'>
       NotasCredito();
		GeneraVuelto();
	</cfif>	--->
	<cfif isdefined('rsTransaccion')>
	 <cfif rsTransaccion.ETnotaCredito EQ 1 or  rsTransaccion.ETgeneraVuelto EQ 1>
	    $( document ).ready(function() {
		    document.getElementById("idTerminar").style.visibility = 'visible';
		 });
	 </cfif>
	</cfif>

	function NotasCredito(){
		<cfoutput>
		<cfif modo NEQ "ALTA">
			document.getElementById('nc').src = 'GeneraNC.cfm?ETnumero='+f.ETnumero.value+'&FCid='+f.FCid.value+'&CGNC='+f.NCredito.checked;
		</cfif>
		<cfif modo NEQ "ALTA" and rsTransaccion.ETestado NEQ "T">

			<cfif  rsTipo.CCTvencim EQ -1>
				if (#LvarNCredito#){

					if(f.NCredito.checked){
						<!---document.getElementById("idTerminar").style.visibility = 'visible';--->
						document.getElementById("GenerarVuelto").checked = false;

					}
					else{
						document.getElementById("idTerminar").style.visibility = 'hidden';
					}
				}
			</cfif>
		</cfif>
		</cfoutput>
	  location.reload();
	}

	function GeneraVuelto(){
		document.form1.submit();
			/*<cfoutput>
			<cfif modo NEQ "ALTA">
				document.getElementById('nc').src = '/sif/fa/operacion/GeneraNC.cfm?ETnumero='+f.ETnumero.value+'&FCid='+f.FCid.value+'&CGNV='+f.GenerarVuelto.checked;
			</cfif>
			<cfif modo NEQ "ALTA" and rsTransaccion.ETestado NEQ "T">

				<cfif  rsTipo.CCTvencim EQ -1>
					if (#LvarHayqueGenerarVuelto#){

						if(f.GenerarVuelto.checked){
							document.getElementById("NCredito").checked = false;
							document.getElementById("idTerminar").style.visibility = 'visible';

						}
						else{
							document.getElementById("idTerminar").style.visibility = 'hidden';

						}
					}
				</cfif>
			</cfif>
			</cfoutput>
 		location.reload();*/
		}


	//Si es LiquidacionRuteros, entonces ocultamos lo que debemos ocultar, como botones.
	<cfif isDefined('form.LiquidacionRuteros')>
	ocultarItemsLiquidacionRuteros();
	function ocultarItemsLiquidacionRuteros(){
		try{document.form1.getElementsByClassName('btnAnterior')[0].style.display = 'none';}catch(e){}
		try{document.getElementById('leerSGA').style.display = 'none';}catch(e){}
		try{document.getElementById('btnRecuperarLinea').style.display = 'none';}catch(e){}
		try{document.getElementById('idAplicar').style.display = 'none';}catch(e){}
		try{document.getElementById('AgregarSGA').style.display = 'none';}catch(e){}
		try{$('input[name="Comisiones"][type="button"]').hide()}catch(e){}
		<cfif isDefined('rsTransaccion.ETexterna') and rsTransaccion.ETexterna EQ 'S'>
			try{document.getElementById('BorrarE').style.display = 'none';}catch(e){}
			try{$('input[name="BorrarD"]').remove();}catch(e){}
		</cfif>
		<!--- Si ya la factura fue aplicada, Eliminamos TODOS los botones de la pantalla --->
		<cfif isDefined("rsTransaccion.ETestado") and rsTransaccion.ETestado EQ 'C'>
			try{
				$('input[type="button"]').remove();
				$('input[type="submit"]').remove();
			}catch(e){}
		</cfif>
	}
	</cfif>
</script>


<cffunction name="PintaEncabezado">
	<div class="contenido">
	<table border="0" cellpadding="0" cellspacing="1" width="100%">
		<tr>
	  		<cfif isDefined('rsTransaccion.ETexterna') and rsTransaccion.ETexterna EQ 'S'>
	  			<label class="etiqueta colorAzul" style="text-align:right;display:block;margin-right:10px;margin-bottom:10px;text-decoration:underline">
	  				Transacción importada desde un sistema externo (<label class="etiqueta" style="color:red">No modificable</label>)
	  			</label>
	  		</cfif>
  		</tr>
		<tr>
			<td class="panelIzquierdo">
				<table border="0" cellpadding="1" cellspacing="0" width="100%">
					<!----------------------------------------------------------------------------------------------
					Linea 0 (UNICAMENTE EN NUEVA PARA UNA LIQUIDACION).
					ETdocumento, ETserie
					----------------------------------------------------------------------------------------------->
					<!--- Solo se muestran cuando la factura pertenece a una liquidacion ETransacciones.ETesLiquidacion = 1 --->
					<cfif isDefined('form.LiquidacionRuteros')>
						<tr>
							<!--- espacios para cuadrar --->
							<td colspan="2"/>
					    	<!--- ETserie --->
							<td width="15%" align="right">
					      		<label class="etiqueta">Número Serie:</label>
					  		</td>
					      	<td width="25%" class="colorAzul etiqueta">
					      		<cfoutput>
					      			<cfset _tempLiquidacionETserie = "">
					      			<cfif modo EQ 'Cambio' and isDefined('rsTransaccion.ETserie') and Len(Trim(rsTransaccion.ETserie))>
					      				<cfset _tempLiquidacionETserie = rsTransaccion.ETserie>
					      			</cfif>
					          		<input name="_liquidacionETserie" type="text" value="#_tempLiquidacionETserie#">
					        	</cfoutput>
					    	</td>
							<!--- ETdocumento --->
							<td width="15%" align="right">
					      		<label class="etiqueta">Número Documento:</label>
					  		</td>
					      	<td width="25%" class="colorAzul etiqueta">
					      		<cfoutput>
					      			<cfset _tempLiquidacionETdocumento = "">
					      			<cfif modo EQ 'Cambio' and isDefined('rsTransaccion.ETdocumento') and rsTransaccion.ETdocumento NEQ -1>
					      				<cfset _tempLiquidacionETdocumento = rsTransaccion.ETdocumento>
					      			</cfif>
					      			<cf_monto name="_liquidacionETdocumento" decimales="0" value="#_tempLiquidacionETdocumento#">
					        	</cfoutput>
					    	</td>
						</tr>
					</cfif>
					<!----------------------------------------------------------------------------------------------
					Linea 1
				    Caja, transaccion, lote, factura, Trans
				    ----------------------------------------------------------------------------------------------->
				    <tr>
				    	<!--- Caja --->
				      	<td width="10%" nowrap align="right">
				      		<cf_notas link="#helpimg#" titulo="Configuración de caja" msg="La caja deber tener asociada una cuenta contable y  una oficina. Esta oficina debe tener una zona de venta configurada.">
				      		<label id="cajaPrinc" class="etiqueta">Caja:</label>

				  			<cfif isdefined('Cookie.CFuncional') and len(trim(#Cookie.CFuncional#)) gt 0>
						      <input name="CFuncional" type="hidden" value="#Cookie.CFuncional#">
						    </cfif>
						    <cfif isdefined('Cookie.Socio') and len(trim(#Cookie.Socio#)) gt 0>
					     	   <input name="Socio" type="hidden" value="#Cookie.Socio#">
						    </cfif>
							<cfif isdefined('Cookie.Documento') and len(trim(#Cookie.Documento#)) gt 0>
						 	   <input name="Documento" type="hidden" value="#Cookie.Documento#">
							</cfif>
				  		</td>
				      	<td width="50%" class="etiqueta">
				      		<cfoutput>
				      			#rsCajas.FCcodigo#&nbsp;#rsCajas.FCdesc#
				          		<input name="FCid" type="hidden" value="#rsCajas.FCid#">
				        	</cfoutput>
				    	</td>
				      <!--- Transaccion --->
				      <td width="8%" align="right">
				      	<label id="transLabel" class="etiqueta">Transacci&oacute;n:</label>
				      </td>
				      <td width="25%">
				      	<cfoutput>
						  <!---Modo Cambio--->
				          <cfif modo NEQ "ALTA">
				            <input type="hidden" name="CCTcodigo" value="#rsTiposTransaccion.CCTcodigo#">
                            <cfif NOT isdefined('rsTipo') OR rsTipo.recordcount eq 0>
                             	<span class="style1">   La caja no tiene la transaccion <strong>#rsTransaccion.CCTcodigo#</strong> ligada. </span>
                            <cfelse>
				            	#rsTipo.CCTdescripcion#
							</cfif>
						 <!---Modo ALTA--->
				          <cfelse>
						  	 <cfif NOT isdefined('rsTiposTransaccion') OR rsTiposTransaccion.recordcount eq 0>
						     	<span class="style1">Favor verificar. Debe haber una relacion entre la Caja - Transacciones - Talonario!.</span>
							 <cfelse>
								<select name="CCTcodigo" onChange="javascript: TraerTransaccion(this.value); asignaTipoPago(this.value);" tabindex="1"
										style="width:150px">
								  <cfloop query="rsTiposTransaccion">
									<option value="#rsTiposTransaccion.CCTcodigo#" <cfif modo NEQ 'ALTA' and rsTiposTransaccion.CCTcodigo EQ rsTransaccion.CCTcodigo>selected</cfif>>#rsTiposTransaccion.CCTdescripcion#</option>
								  </cfloop>
								</select>
							</cfif>
				          </cfif>
				        </cfoutput>
				       </td>

				      <!--- Lote y Numero de Factura --->
				      <td nowrap align="right">
				          		Lote:
                       <!--- </td>
                       <td nowrap align="center"> --->
                           <cfoutput>
				          		<cfif isDefined('form.LiquidacionRuteros')> <!--- es de liquidacion. Mostramos el Lote, Y asi se guardara. --->
				          			<cfif modo EQ 'ALTA'>
				          				<input type="text" value="#form.ETLote#" disabled>
				          				<input type="hidden" name="ETLote" value="#form.ETLote#">
				          			<cfelse>
				          				<label class="etiqueta">#rsTransaccion.ETlote#</label>
				          			</cfif>
				          		<cfelse> <!--- NO es de Liquidacion, funcionamiento normal --->
					                <cfif modo EQ "ALTA">
					          			<input type="text" name="ETLote" size="5"/>
					          		<cfelse>
					          			<label class="etiqueta">#rsTransaccion.ETlote#</label>
					          		</cfif>
				          		</cfif>
				        </cfoutput>
				      </td>
				      <!--- ETnumero --->
				      <!------------>
				      <td class="tdTrans" nowrap>
				      	<cfoutput>

				      			 &nbsp
				          		 <label id="lote" class="etiqueta">Trans.</label>
				          		 <cfif modo NEQ "ALTA">
				          		 	<label class="etiqueta">#rsTransaccion.ETnumero#&nbsp;</label>
				          		 </cfif>

				        </cfoutput>
				       </td>

				       <cfif modo EQ 'ALTA'>
				       	<script>
					      	$(document).ready(function(){
					      		$('.tdTrans').remove();
					      		$('.tdLote').attr('colspan','2');
					      		<cfif isDefined('form.LiquidacionRuteros') or (isDefined('rsTransaccion.ETesLiquidacion') and rsTransaccion.ETesLiquidacion EQ 1)>
					      			$('.tdLote input').css('margin-right','35px');
					      		<cfelse>
					      			$('.tdLote input').css('margin-right','60px');
					      		</cfif>
					      	});
					     </script>
				      </cfif>

				    </tr>

				    <!----------------------------------------------------------------------------------------------
					Linea 2
				    Cliente, Moneda, Tipo Cambio
				    ------------------------------------------------------------------------------------------------>
				    <tr>
				    	<!--- Cliente --->
					  	<td align="right">
					  		<label id="clienteLabel" class="etiqueta">Cliente:</label>
					  	</td>
						<td>
                        <iframe id="frame1" width="1" height="1" frameborder="0">&nbsp;</iframe>
						  	<cfif modo NEQ "ALTA">
								<cfoutput>
									#rsNombreSocio.SNnombre#
									<input type="hidden" name="SNnombre" value="#rsNombreSocio.SNnombre#">
									<input type="hidden" name="SNcodigo" value="#rsTransaccion.SNcodigo#">
									<input type="hidden" name="SNid"     value="#rsNombreSocio.SNid#">
								</cfoutput>
							<cfelse>
								<cfif moduloOrigen eq "CRC">
									<cf_conlis
										Campos="SNid,SNcodigo,SNnumero,SNnombre"
										Desplegables="N,N,S,S"
										Modificables="N,N,S,N"
										Size="0,0,10,30"
										tabindex="2"
										Tabla="Snegocios s inner join CRCCuentas c
												on c.SNegociosSNid = s.SNid
												and c.Tipo in ('D','TC','TM')"
										Columnas="distinct SNid,SNcodigo,SNnumero,SNnombre"
										form="form1"
										Filtro=" s.Ecodigo = #Session.Ecodigo# and (disT = 1 or Mayor = 1 or TarjH = 1) and s.eliminado is null
												order by SNnombre"
										Desplegar="SNnumero,SNnombre"
										Etiquetas="Número, Nombre"
										filtrar_por="SNnumero,SNnombre"
										funcion="funcAsignar"
										Formatos="S,S"
										Align="left,left"
										Asignar="SNid,SNcodigo,SNnumero,SNnombre"
										Asignarformatos="S,S,S,S"/>
								<cfelse>
									<!--- getSocioNegPorDefault --->
									<cfif getSocioNegPorDefault.recordCount GT 0>
										<cf_sifsociosnegocios2 SNtiposocio="C" frame="frame1"  FuncJSalCerrar="AsignarNombre(); ObtenerAplicaRetencion();" FuncJSalModificar="fn_direcciones(this.value);" idquery="#getSocioNegPorDefault.SNcodigo#" tabindex="3">
									<cfelse>
										<cfif rsClienteContado.recordcount and isdefined("rsClienteContado.Pvalor") and rsClienteContado.Pvalor>
									    	<cf_sifsociosnegocios2 SNtiposocio="C" frame="frame1"  FuncJSalCerrar="AsignarNombre(); ObtenerAplicaRetencion();" FuncJSalModificar="fn_direcciones(this.value);" idquery="#rsClienteContado.Pvalor#" tabindex="3">
									    <cfelse>
									        <cf_sifsociosnegocios2 SNtiposocio="C" frame="frame1" FuncJSalCerrar="ObtenerAplicaRetencion(); AsignarNombre();" FuncJSalModificar="ObtenerAplicaRetencion();AsignarNombre(); <!---funcSNnumero2();fn_direcciones(this.value);--->" tabindex="3">
									    </cfif>
									</cfif>
								</cfif>
                              <!---  <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P"  frame="frame1" FuncJSalModificar="">
                              <cf_sifSNFactCxC SNtiposocio="C" SNidentificacion ="SNidentificacion" size="50" tabindex="1">--->
						    </cfif>
						</td>
					    <!--- Moneda --->
					    <td align="right">
					      	<label id="monedaLabel" class="etiqueta">Moneda:</label>
					    </td>
				    	<td>
				    		<cfif modo NEQ "ALTA">
				          		<cf_sifmonedas cualTC="C" query="#rsTransaccion#" valueTC="#rsTransaccion.ETtc#" onChange="asignaTC();" FechaSugTC="#LSDateFormat(rsTransaccion.ETfecha,'DD/MM/YYYY')#" tabindex="4">
				          	<cfelse>
					             <cf_sifmonedas cualTC="C" onChange="asignaTC();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="4" style="width:150px">
					        </cfif>
							<cfif modo neq 'ALTA' and rsDetalles.RecordCount gt 0>
								<script language="javascript1.2" type="text/javascript">
									//document.form1.Mcodigo.disabled = true;
									document.form1.Mcodigo.style.border = '0';
								</script>
							</cfif>
							<input name="Ocodigo" type="hidden" value="<cfoutput>#rsCajas.Ocodigo#</cfoutput>">
						</td>
					    <!--- Tipo de Cambio --->
					    <td width="18%" nowrap align="right">
					      	<label id="TClabel" class="etiqueta">Tipo Cambio:</label>
					    </td>
					    <td colspan="2" align="left">
					    	<input type="text" name="ETtc" class="inputMonto <cfif modo EQ 'CAMBIO'>noBorder</cfif>" tabindex="5"
					    	    style="text-align:right;width:50px" maxlength="10"
								onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
								onFocus="javascript:this.select();"
								onChange="javascript: fm(this,4);"
								value="<cfif modo NEQ 'CAMBIO'>1.00<cfelse><cfoutput>#LSNumberFormat(rsTransaccion.ETtc,',9.0000')#</cfoutput></cfif>">
					        <input name="Ccuenta" type="hidden" value="<cfoutput>#rsCajas.Ccuenta#</cfoutput>">
					    </td>
				    </tr>

				    <!----------------------------------------------------------------------------------------------
					Linea 3
				    Cliente Detallista, Agencia
				    ------------------------------------------------------------------------------------------------>
				    <tr>
				    	<!--- Cliente Detallista --->
				        <td nowrap="nowrap" align="right" style="vertical-align: top">
				        	<label id="docLabel" class="etiqueta">
					        	<cfif getSocioNegPorDefault.recordCount GT 0>
						        	Nombre en el Documento:
								<cfelse>
									<cfif rsClienteContado.recordcount and isdefined("rsClienteContado.Pvalor") and modo EQ 'ALTA'>Cliente Detallista:
					        		<cfelseif rsClienteContado.recordcount and isdefined("rsClienteContado.Pvalor") and modo NEQ 'ALTA' and rsClienteContado.Pvalor eq rsTransaccion.SNcodigo>
					        			Cliente Detallista:
					        		<cfelse>
					        		</cfif>
								</cfif>

				        	</label>
				        </td>


				     	<!--- una u otra --->
				        <td id="clienteDet" <cfif getSocioNegPorDefault.recordCount GT 0>style="display:none"</cfif> <cfif rsClienteContado.recordcount and isdefined("rsClienteContado.Pvalor") and modo EQ 'ALTA'><cfelseif rsClienteContado.recordcount and isdefined("rsClienteContado.Pvalor") and modo NEQ 'ALTA' and rsClienteContado.Pvalor eq rsTransaccion.SNcodigo><cfelse>style="display:none;"</cfif>>
					        <cfoutput>
					        	<cfif modo NEQ "ALTA">
					          		<cf_sifClienteDetCorp2 CDCcodigo="CDCcodigo" form='form1'  idquery="#rsTransaccion.CDCcodigo#" tabindex="6" Nuevo="true">
					            <cfelse>
					            	<cf_sifClienteDetCorp2 CDCcodigo="CDCcodigo" form='form1'  tabindex="6" Nuevo="true">
					            </cfif>
					        </cfoutput>
				        </td>
				       	<td id="nombreDoc" <cfif getSocioNegPorDefault.recordCount EQ 0>style="display:none"</cfif> colspan="5"> <!--- una u otra --->
							<cfoutput>
								<cfif modo NEQ 'ALTA' and len(trim(#rsTransaccion.CDCcodigo#)) eq 0 >
									<script> document.getElementById("nombreDoc").style.display="";</script>
								</cfif>
								<cfif modo EQ 'ALTA'>
								<cfif getSocioNegPorDefault.recordCount GT 0>
									<input id="name" name="ETnombredoc" type="text" value="#HTMLEditFormat(Trim(getSocioNegPorDefault.SNnombre))#" size="44" maxlength="255">
								<cfelse>
									<input id="name" name="ETnombredoc" type="text" value="<cfif modo NEQ 'ALTA' and len(trim(#rsTransaccion.CDCcodigo#)) eq 0 >#HTMLEditFormat(Trim(rsTransaccion.ETnombredoc))#</cfif>" size="44" maxlength="255">
								</cfif>
								<cfelse>
									<p>
										<cfif len(trim(#rsTransaccion.CDCcodigo#)) eq 0 >
											#HTMLEditFormat(Trim(rsTransaccion.ETnombredoc))#
										</cfif>
									</p>
								</cfif>
							 </cfoutput>
						</td>

                   <cfif rsAgencias.Existen gt 0>
				        <!--- Agencia --->
				        <td align="right" style="vertical-align:middle">
				       		<label id="AgenciaLabel" class="etiqueta">Agencia:</label>
				       	</td>
				        <cfif modo NEQ "ALTA">
				        	<td colspan="4" style="vertical-align:middle">
				         		<cfoutput>
						            <cfif isdefined('rsSocio2')>
						                #rsSocio2.SNnumero# &nbsp;&nbsp;#rsSocio2.SNnombre#
						            <cfelse>
						                No definido
						            </cfif>
				                </cfoutput>
				            </td>
				        <cfelse>
						    <td colspan="4" id="listaAgenciasCol">
						    	<cf_conlis
									title="Lista de Agencias"
									campos = "SNidentificacion2,SNcodigo2,SNnombre2 "
									desplegables = "S,S,S"
									modificables = "N,S,S"
									size = "10,20,20"
									tabla="SNegocios a, RolEmpleadoSNegocios b"
									columnas="a.SNcodigo as SNcodigo2, a.SNidentificacion as SNidentificacion2 , b.RESNtipoRol, b.AliasRol,
					        					a.SNnombre as SNnombre2 , b.RESNtipoRol"
									filtro="a.Ecodigo = #Session.Ecodigo#
											  and a.Ecodigo = a.Ecodigo
					                          and a.SNcodigo =  b.SNcodigo
					                          and b.RESNtipoRol = 4
											 "
									desplegar="SNcodigo2,SNidentificacion2,SNnombre2 "
									filtrar_por="a.SNcodigo,SNidentificacion,SNnombre "
									etiquetas="Codigo, Identificacion,Nombre"
									formatos="S,S,S"
									align="left,left,left"
									asignar="SNidentificacion2,SNcodigo2,SNnombre2"
									asignarformatos="S,S,S"
									left="125"
									top="100"
									width="750"
									tabindex="1">
					        </td>
				        </cfif>
				        </tr>
						</cfif>
						<tr>
							<td colspan="6">
								<hr style="margin:0;margin-bottom:10px;margin-left:1em;margin-right:1em;padding;0;"/>
							</td>
						</tr>
						<!----------------------------------------------------------------------------------------------
						Linea 4
					    Direccion, Centro Funcional
					    ------------------------------------------------------------------------------------------------>
						<tr>
							<!--- Direccion --->
				        	<td align="right">
				        		<label id="DirLabel" class="etiqueta">Direcci&oacute;n:</label>
				        	</td>
				        	<td>
								<cfif modo eq 'ALTA'>
	                               <select style="width:470px" tabindex="1" name="DireccionSN" id="id_direccion" <!---<cfif getSocioNegPorDefault.recordCount EQ 0>onfocus="fncCambioDir();"</cfif>--->>
									<!--- texto_direccion --->
									<!---
									<cfif getSocioNegPorDefault.recordCount GT 0>
										<cfoutput><cfloop query="getSNDirDefault">
											<option value="#getSNDirDefault.id_direccion#">#getSNDirDefault.texto_direccion#</option>
										</cfloop></cfoutput>
									<cfelse>
										<option value="">- Ninguna -</option>
									</cfif>
									--->
	                               </select>
								<cfelse>
									<!--- <cfoutput>#rsTransaccion.SNdireccion#</cfoutput> --->
									<cfoutput>#rsTransaccion.Texto_direccion#</cfoutput>
						 		</cfif>
						 		<!--- ALH---Validación de la Dirección, que sea requerida --->
						 		<script>
									$("#id_direccion").prop("required",true);
								</script>
				        	</td>
							<!--- Centro Funcional --->
							<td align="right">
								<label id="CFlabel" class="etiqueta">C.Funcional:</label>
							</td>
							<td colspan="3">
								<cfset valuesArraySN = ArrayNew(1)>
								<cfif isdefined("rsTransaccion.CFid") and len(trim(rsTransaccion.CFid))>
									<cfquery datasource="#Session.DSN#" name="rsSN">
										select
										CFid,
										CFcodigo,
										CFdescripcion
										from CFuncional
										where Ecodigo = #session.Ecodigo#
										and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTransaccion.CFid#">
									</cfquery>
									<cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
									<cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
									<cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
								</cfif>
								<cfif modo EQ 'ALTA'>
									<cf_conlis
										Campos="CFid,CFcodigo,CFdescripcion"
										valuesArray="#valuesArraySN#"
										Desplegables="N,S,S"
										Modificables="N,S,N"
										Size="0,10,20"
										tabindex="5"
										Title="Lista de Centros Funcionales"
										Tabla="CFuncional cf
										inner join Oficinas o
										on o.Ecodigo=cf.Ecodigo
										and o.Ocodigo=cf.Ocodigo"
										Columnas="distinct cf.CFid,cf.CFcodigo,cf.CFdescripcion #LvarCNCT# ' (Oficina: ' #LvarCNCT# rtrim(o.Oficodigo) #LvarCNCT# ')' as CFdescripcion"
										Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
										Desplegar="CFcodigo,CFdescripcion"
										Etiquetas="Codigo,Descripcion"
										filtrar_por="cf.CFcodigo,CFdescripcion"
										Formatos="S,S"
										Align="left,left"
										form="form1"
										Asignar="CFid,CFcodigo,CFdescripcion"
										traerinicial="true"
										traerfiltro="o.Ocodigo = '#rscajas.Ocodigo#'"
										Asignarformatos="S,S,S,S"
									/>
								<cfelse> <!--- Modo cambio --->
									<cfoutput>
										<p>
											<cfif isdefined("rsSN.CFcodigo") and isdefined("rsSN.CFdescripcion")>
												#rsSN.CFcodigo# - #rsSN.CFdescripcion#
											</cfif>
										</p>
									</cfoutput>
								</cfif>
								<!--- ALH---Validación del Centro Funcional que sea requerido --->
								<script>
									$("#CFcodigo").prop("required",true);
								</script>
							</td>
						</tr>

						<!----------------------------------------------------------------------------------------------
						Linea 5
					    Zona de venta, Descuento
					    ------------------------------------------------------------------------------------------------>
                        <tr>
							<td colspan="6">
								<hr style="margin:0;margin-bottom:5px;margin-top:10px;margin-left:1em;margin-right:1em;padding;0;"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr>
										<!--- Zona de Venta --->
										<td align="right">
											<label id="zonaLabel" class="etiqueta">Zona de Venta:</label>
										</td>
								        <td>
								        	<cfif modo EQ 'ALTA'>
									        	<input type="text" name="zona" id="zona"
									        	       value="<cfoutput>#rsCajas.nombre_zona#</cfoutput>" size="30" disabled/>
								        	<cfelse>
								        		<p>
								        			<cfoutput>#rsCajas.nombre_zona#</cfoutput>
								        		</p>
								        	</cfif>
								        	<input type="hidden" value="<cfoutput>#rsCajas.id_zona#</cfoutput>" name="id_zona">
								        </td>
									</tr>
									<!---  Retencion al pagar --->
									<tr id="aplicaRet" style="display:none;">
									<cfif (modo EQ 'ALTA' or modo EQ 'CAMBIO')>
										<td align="right">
											<label id="ret" class="etiqueta"> Retenci&oacute;n:&nbsp;</label>
										</td>
										<td colspan="2">
											<!--- Solo se muestra cuando el modo es ALTA o cuando es Cambio y el Socio SI permite Aplica Retencion --->

												<cfquery name="rsRetenciones" datasource="#Session.DSN#">
										            select Rcodigo, Rdescripcion from Retenciones
										            where Ecodigo =  #Session.Ecodigo#
										            order by Rdescripcion
										        </cfquery>
												<select name="Rcodigo" tabindex="1">
													<option value="-1" >-- Sin Retención --</option>
													<cfoutput query="rsRetenciones">
														<option value="#rsRetenciones.Rcodigo#"
															<cfif modo NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsTransaccion.Rcodigo>selected
															<cfelseif modo EQ 'ALTA' and isdefined('Form.Rcodigo')
																	  and rsRetenciones.Rcodigo EQ Form.Rcodigo> selected
															</cfif>
						                                    >
															#rsRetenciones.Rdescripcion#
														</option>
													</cfoutput>
												</select>
												<cfif modo EQ 'CAMBIO'>
													<script>
														document.form1.Rcodigo.style.border = '0';
														<cfif rsTransaccion.ETexterna EQ 'S'>
															document.form1.Rcodigo.disabled = 'true';
														</cfif>
													</script>
												</cfif>
												<!--- Si es Cambio y rsNombreSocio.SNRetencion EQ 0 entonces mostramos que la retencion no esta permitida --->
											<cfelseif modo EQ 'CAMBIO' and rsNombreSocio.SNRetencion EQ 0>
												<div style="color:blue;min-width:150px;"> No disponible </div>
											</td></cfif>
										
									</tr>
									<!--- Cambio de la retencion en caso de ser sistema externo --->
									<cfif modo EQ 'CAMBIO' and rsTransaccion.ETexterna EQ 'S' and rsNombreSocio.SNRetencion EQ 1>
										<tr>
											<td colspan="3" style="text-align:center">
												<!--- Confirm que se levanta para modificar la retencion --->
												<cf_Confirm width="50" index="2" Botones="Modificar Retención,Cancelar"
														    title="Modificando Retención..."
												            funciones="modificarRetencionManual(event)">
												 	<div id="dialogModificarRetencionManual">
												 		<label for="_retencionManual">Retención:</label>
												 		<select id="RcodigoManual" name="RcodigoManual" tabindex="1">
															<option value="-1" >-- Sin Retención --</option>
															<cfoutput query="rsRetenciones">
																<option value="#rsRetenciones.Rcodigo#"
																	<cfif modo NEQ "ALTA"
																	      and rsRetenciones.Rcodigo EQ rsTransaccion.Rcodigo>selected
																	<cfelseif modo EQ 'ALTA' and isdefined('Form.Rcodigo')
																	  and rsRetenciones.Rcodigo EQ Form.Rcodigo> selected
																	</cfif>
						                                    	>
															#rsRetenciones.Rdescripcion#
														</option>
													</cfoutput>
												</select>
												 	</div>
												</cf_Confirm>
												<input type="button" id="btnModificarRetencion" name="btnModificarRetencion"
												       class="btnNormal" value="Modificar Retención" onClick="PopUpAbrir2();">
											</td>
										</tr>
									</cfif>

								</table>
							</td>
					        <!--- Descuento --->
					        <td colspan="2">
						        <cfif moduloOrigen neq "CRC">
						        <table cellpadding="0" cellspacing="0" style="border:1px solid #C0C0C">
						        	<tr style="border-bottom:1px solid rgb(213, 196, 196)">
						        		<td colspan="2" style="text-align:center">
						        			<label id="desc" class="etiqueta">Descuento</label>
						        		</td>
						        	</tr>
						        	<tr>
						        		<td>
						        			<label class="etiqueta">
						        			    <cfif modo EQ 'ALTA'>
						        					<input name="chkPorcentaje" type="radio" cheked
												   value="radio"
			                    				   onClick="javascript:document.form1.chkMonto.checked = false; calculaDescuento()">
			                    				    Porcentaje
			                    				</cfif>
		              						</label>
		              					</td>
	                                       <cfset LvarMontoDescuento = 0.00>
	                                   <cfif modo EQ 'CAMBIO' and rsTransaccion.ETmontodes gt 0 and rsTransaccion.ETporcdes eq 0>
	                                   	   <cfset LvarMontoDescuento = rsTransaccion.ETmontodes>
	                                   <cfelseif  modo EQ 'CAMBIO' and rsTransaccion.ETporcdes gt 0>
	                                       <cfset LvarMontoDescuento = rsTransaccion.ETporcdes>
							            </cfif>


						        		<td rowspan="2">
						        			<cfoutput>
						        				<cfif modo EQ 'CAMBIO' and rsTransaccion.ETporcdes gt 0>
	                                                <strong>	Porcentaje</strong>
						        				<cfelseif  modo EQ 'CAMBIO' and rsTransaccion.ETmontodes gt 0 and rsTransaccion.ETporcdes eq 0>
	                                                <strong>    Monto  </strong>
	                                            </cfif>
						        			<cfif modo EQ 'ALTA'>

											<input name="Descuento" type="text" size="12" tabindex="1"
				              				       maxlength="12" style="text-align:right"
							                       onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							                       onFocus="javascript:this.select();"
							                       onChange="javascript: fm(this,2); calculaDescuento();"
							                       value="0.00">
							                 <cfelseif modo EQ 'CAMBIO' and rsTransaccion.ETmontodes gt 0>
							                 	  #LSCurrencyFormat(LvarMontoDescuento,'none')#
							                 	  <input type="hidden" name="Descuento" value="#LvarMontoDescuento#">
							                 <cfelseif LvarMontoDescuento eq 0>
							                    - Sin Descuento -
							                    <input type="hidden" name="Descuento" value="0">
							                 </cfif>

			              					<input type="hidden" name="ETporcdes"
			              					       value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsTransaccion.ETporcdes,'none')#<cfelse>0.00</cfif>">
			              					<input type="hidden" name="ETmontodes"
			              					       value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsTransaccion.ETmontodes,'none')#<cfelse>0.00</cfif>">
			              					</cfoutput>
						        		</td>
						        	</tr>
						        	<tr>
						        		<td>
						        			<label class="etiqueta">
						        			       <cfif modo EQ 'ALTA'>
						        					<input type="radio" name="chkMonto"
							                    	   onClick="javascript:document.form1.chkPorcentaje.checked = false; calculaDescuento()"
							                    	   value="radio">
							                    	Monto

							                    </cfif>

	              				    		</label>
						        		</td>
						        	</tr>

						        	<cfif modo EQ 'CAMBIO'>
						        		<script>
						        			document.form1.chkPorcentaje.disabled = "true";
						        			document.form1.chkMonto.disabled = "true";
						        			document.form1.Descuento.disabled = "true";
						        			document.form1.Descuento.style.border = "0";
						        		</script>
						        	</cfif>
						        </table>
							</cfif>
					        </td>

					        <cfif (modo NEQ 'ALTA' or modo NEQ 'CAMBIO') AND IsDefined("rsTRetencion") AND rsTRetencion.RecordCount GT 0 >

								<td colspan="3" style="text-align:center">
									<!---Lista las retenciones  aplicadas si no es mpdp alta ni cambio --->
								<label for="_retencionManual">Retención:</label>
								<ul>
									<cfoutput query="rsTRetencion">
										<li>#Descripcion#</li>
									</cfoutput>
								</ul>
								</td>
							</cfif>
					        &nbsp;
					        <!--- Observaciones --->
					        <td colspan="2">&nbsp;

					        </td>
						</tr>
                         <tr>
	                       <!--- Observaciones --->
					        <td colspan="6" align="center">
								<label id="ObsLabel" class="etiqueta" style="display:block">
									Observaci&oacute;n
								</label>
								<cfoutput>
					            	<textarea name="ETobs" maxlength="1500"  id="ETobs" style="resize:both;width:298px;min-width:298px;height:50px;min-height:50px;border-color:rgb(213, 196, 196)"><cfif modo NEQ 'ALTA'>#HTMLEditFormat(trim(rsTransaccion.ETobs))#</cfif></textarea>
					        	</cfoutput>
					        </td>
						</tr>

						<tr>
							<td colspan="6">
								<hr style="margin:0;margin-bottom:5px;margin-top:10px;margin-left:1em;margin-right:1em;padding;0;"/>
							</td>
						</tr>
					    <tr>
							<td colspan="3"></td>
							<!---  Crear nota de credito o pago --->
							<td colspan="3">

								<div id="NC" <cfif  LvarNCredito eq false>
												style="visibility:hidden;text-align:right;padding-right:4px"
											 <cfelse>
											 	style="text-align:right;"
											 </cfif>>
		    						<input type="checkbox" id="NCredito" name="NCredito"  <cfif not LvarNCredito> disabled="disabled" </cfif>

		    							   style="position: relative; top: 2px;display:inline"
		    							   onclick="javascript: <cfif modo neq "ALTA" and isdefined('rsTransaccion') and rsTransaccion.ETestado eq 'T'> return false; <cfelse>NotasCredito();</cfif>"
		    							   <cfif modo neq "ALTA" and rsTransaccion.ETnotaCredito eq 1>checked</cfif>>
		    						<label id="NCredit" class="etiqueta" style="display:inline">Crear Nota de Cr&eacute;dito para los Dep&oacute;sitos &oacute; Cheques</label>
		    					</div>
		    				</td>
						</tr>
                        <tr>
							<td colspan="3"></td>
							<!---  Registrar Vuelto --->
							<td colspan="3">
								<!--- <div id="Vuelto" <cfif LvarHayqueGenerarVuelto eq false>
												style="visibility:hidden;text-align:right;padding-right:4px"
											 <cfelse>
											 	style="text-align:right;"
											 </cfif>>
		    						<input type="checkbox" id="GenerarVuelto" name="GenerarVuelto"  <cfif not LvarHayqueGenerarVuelto> disabled="disabled" </cfif>

		    							   style="position: relative; top: 2px;display:inline"
		    							   onclick="javascript: <cfif modo neq "ALTA" and isdefined('rsTransaccion') and rsTransaccion.ETestado eq 'T'> return false; <cfelse>GeneraVuelto();</cfif>"
		    							 <cfif modo neq "ALTA" and isdefined('form.GenerarVueltoInd') and form.GenerarVueltoInd eq 1>checked</cfif>>
		    						<label id="GeneraVuelto" class="etiqueta" style="display:inline">Registrar como vuelto</label>
		    					</div> --->
		    				</td>
						</tr>
                      	<!--- Botones --->
						<tr>
							<td colspan="6" align="center">
				          		<cfif modo EQ "ALTA">
						            <input name="AgregarE" class="btnGuardar" tabindex="1" type="submit" value="Agregar"
									  	   onClick="javascript: if (valida())
																return true;

															else {
																var f = document.form1;
																f.ETimpuesto.value = fm(f.ETimpuesto.value,2);
																f.ETtotal.value = fm(f.ETtotal.value,2);
																return false;
															}">
					                <input type="button" tabindex="1" name="Regresar" class="btnAnterior" value="Regresar" onClick="javascript:Lista();">
				          		</cfif>
							</td>
						</tr>
						<!--- Panel de recupera --->
						<tr>
							<td colspan="6">
								<div id="pnlRecuperar" style="display:none" class="row contenedorFA">
									<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
								         <td>
											<div class="col-xs-12 contenido">
												<cfoutput>
												<cfset params = "sinTitulo">
												<cfif isDefined('rsTransaccion.ETnumero') and Len(Trim(rsTransaccion.ETnumero))>
													<cfset params = params & "&ETnumero=#rsTransaccion.ETnumero#">
													<cfset params = params & "&Mcodigo=#rsTransaccion.Mcodigo#">
													<cfset params = params & "&SNcodigo=#rsTransaccion.SNcodigo#">
													<cfif isdefined('rsTransaccion.SNcodigo2') and len(trim(#rsTransaccion.SNcodigo2#)) gt 0>
														<cfset _SNcodigo2 = rsTransaccion.SNcodigo2>
														<cfelse> <cfset _SNcodigo2 = 0> </cfif>
													<cfset params = params & "&SNcodigoAgencia=#_SNcodigo2#">
													<iframe src="pnlRecuperarFacturas.cfm?#params#" width="100%" height="500px" frameborder="0" scriptolling="si" id="iframe"></iframe>
												</cfif>
												</cfoutput>
											</div>
								      	</td>
								      <tr>
						     	    </table>
					     		</div>
							</td>
						</tr>
				</table>
			</td>

			<!--- Division de paneles --->

			<td class="panelDerecho">
			<!--- <table width="100%" cellspacing="1" cellpadding="1"> --->
				<!--- Impuesto
				<tr>--->
			<div class="row">
				<cfoutput>
				<div class="col-xs-12 col-md-8">
				<div class="input-group">
				  <label id="impuesto">Impuesto:</label>
				  <input type="text"
				  					name="ETimpuesto" style="text-align:right"
								   onChange="javascript: fm(this,2);"  readonly tabindex="-1"
						           value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsTransaccion.ETimpuesto,'none')#</cfoutput><cfelse>0.00</cfif>" size="18" maxlength="18">
				</div>

					<!--- <td align="right"><label id="impuesto">Impuesto:</label></td>
			        <td colspan="2">
			        		<input type="text" name="ETimpuesto" style="text-align:right"
								   onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
						           value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsTransaccion.ETimpuesto,'none')#</cfoutput><cfelse>0.00</cfif>" size="18" maxlength="18">
					</td>
				</tr>--->
				<!--- SubTotal --->
				<div class="input-group">
				  <label id="subtLabel">SubTotal:</label>
				  <input type="text"
				  					name="subtotal" style="text-align:right;"
								   onChange="javascript: fm(this,2);" readonly tabindex="-1"
								   value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsSubTotal.subtotal,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18">
				</div>
				<!---<tr>
					<td nowrap align="right"><label id="subtLabel">SubTotal:</label></td>
      				<td colspan="2">
      					<cfoutput>
      						<input name="subtotal" type="text" style="text-align:right;"
								   onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
								   value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsSubTotal.subtotal,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18">
						</cfoutput>
					</td>
				</tr>--->
				<cfif moduloOrigen neq "CRC">
				<!--- Descuento --->
				<div class="input-group">
				  <label id="descuentoDet"> Descuento: </label>
				  <input type="text"
				  					name="ETdescuentoE" style="text-align:right;color:red"
								   onChange="javascript: fm(this,2);"  readonly tabindex="-1"
							       value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(LvarMontoDesc,'none')#<cfelse>0.00</cfif>"
							       size="18" maxlength="18">
				</div>
				</cfif>
				<!---<tr>
					<td align="right">
						<label id="descuentoDet"> Descuento: </label>
					</td>
				    <td>
				    	<cfoutput>
				        	<input name="ETdescuentoE" type="text" style="text-align:right;color:red"
								   onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
							       value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(LvarMontoDesc,'none')#<cfelse>0.00</cfif>"
							       size="18" maxlength="18">
				        </cfoutput>
				    </td>
				</tr>
				<tr>
					<td colspan="2">
						<hr style="margin:0;border-color:#0079C1"/>
					</td>
				</tr>--->
				<!--- Total --->
				<div class="input-group">
				  <label id="totGen">Total:</label>
				  <input type="text"
				  					name="ETtotal" style="text-align:right;font-weight:bold;border:0"
							     onChange="javascript: fm(this,2);" readonly tabindex="-1"
							     value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsTransaccion.ETtotal,'none')#<cfelse>0.00</cfif>"
							     size="18" maxlength="18">
				</div>
				<!---<tr>
					<td align="right">
						<label id="totGen">Total:</label>
					</td>
      				<td colspan="2">
      					<cfoutput>
				          <input name="ETtotal" type="text" style="text-align:right;font-weight:bold;border:0"
							     onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
							     value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(rsTransaccion.ETtotal,'none')#<cfelse>0.00</cfif>"
							     size="18" maxlength="18">
				        </cfoutput>
				    </td>
				</tr>--->
				<!--- Retencion --->
					<cfset montoRetencion = 0>
					<cfif modo NEQ "ALTA">
						<cfquery name="rsRetencion" datasource="#session.dsn#">
							select 	coalesce(r.Rporcentaje,0) / 100.0 *
									coalesce(e.ETtotal  - e.ETmontodes
								,0.00) as Monto
							from ETransacciones e
								left join Retenciones r
									on r.Ecodigo = e.Ecodigo
								and r.Rcodigo = e.Rcodigo
							where e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
							and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
						</cfquery>
						<cfset montoRetencion = rsRetencion.Monto>
					</cfif>
				<!---
					<div class="input-group">
					  <label>Retención:</label>


					  <input type="text"
										name="ETmontoRetencion" style="text-align:right;"
										readonly tabindex="-1"
									   value="<cfoutput>#montoRetencion#</cfoutput>"
									   size="18" maxlength="18">
					</div>
				--->
				<!---<tr>
					<td align="right">
						<label>Retención:</label>
					</td>
					<td>
						<!--- monto de la retencion --->
						<cfset montoRetencion = 0>
						<cfif modo NEQ "ALTA">
			               <cfquery name="rsRetencion" datasource="#session.dsn#">
								select 	coalesce(r.Rporcentaje,0) / 100.0 *
										coalesce(e.ETtotal  - e.ETmontodes
									,0.00) as Monto
								from ETransacciones e
									left join Retenciones r
									 on r.Ecodigo = e.Ecodigo
									and r.Rcodigo = e.Rcodigo
								where e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
			                    and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
							</cfquery>
							<cfset montoRetencion = rsRetencion.Monto>
			            </cfif>
			            <input name="ETmontoRetencion" type="text" style="text-align:right;"
								   class="" readonly tabindex="-1"
							       value="<cfoutput>#montoRetencion#</cfoutput>"
							       size="18" maxlength="18">
					</td>
				</tr>--->
				<!--- Comision --->
				<cfif modo NEQ "ALTA">
					<cfquery name="rsComision" datasource="#Session.DSN#">
						select coalesce(sum(ETcomision),0) as ComisionTotal
						from ETransacciones
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
						<!--- select coalesce(sum(ProntoPagoCliente),0) as ComisionTotal
						from DTransacciones
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
							and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
							and ProntoPagoClienteCheck = 1 --->
					</cfquery>
					<cfif rsComision.recordcount eq 0>
						<cfset rsComision.ComisionTotal = 0>
					</cfif>
				</cfif>
				<div class="input-group">
				  <label>Comisión:</label>


				  <input type="text"
				  					name="Comisiones"
					    	   style="text-align:right"
			                   onChange="javascript: fm(this,2);" readonly tabindex="-1"
			                   value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsComision.ComisionTotal,'none')#</cfoutput><cfelse>0.00</cfif>"
			                   size="18" maxlength="18">
				</div>
				
				<!---<tr>
					<td align="right">
						<label>Comisión:</label>
					</td>
					<td>
                    <cfif modo NEQ "ALTA">
						<cfquery name="rsComision" datasource="#Session.DSN#">
							select coalesce(sum(ProntoPagoCliente),0) as ComisionTotal
							from DTransacciones
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
							  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
							  and ProntoPagoClienteCheck = 1
						</cfquery>
					    <cfif rsComision.recordcount eq 0>
					    	<cfset rsComision.ComisionTotal = 0>
					    </cfif>
                    </cfif>
					    <input type="text" name="Comisiones"
					    	   style="text-align:right"
			                   onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
			                   value="<cfif modo NEQ 'ALTA'><cfoutput>#LSCurrencyFormat(rsComision.ComisionTotal,'none')#</cfoutput><cfelse>0.00</cfif>"
			                   size="18" maxlength="18">
					</td>
				</tr>--->
				<!--- Total Pagado --->
				<div class="input-group">
				  <label id="totalPagado">Total Pagado:</label>

					<cfoutput>
					    <cfif modo NEQ 'ALTA'>
					        <cfset LvarTotalPagado = rsFPagos3.FPagoDoc - LvarVuelto >
						<cfelse>
						    <cfset LvarTotalPagado = 0.00>
					    </cfif>
		          		<input type="text"
				  					name="ETtotalPagado" style="text-align:right;"
							   onChange="javascript: fm(this,2);"  readonly tabindex="-1"
					           value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(LvarTotalPagado,'none')#<cfelse>0.00</cfif>"
					           size="18" maxlength="18">
		        	</cfoutput>
				</div>
				<!---<tr>
					<td nowrap align="right">
						<label id="totalPagado">Total Pagado:</label>
					</td>
			        <td colspan="2">
			        	<cfoutput>
						    <cfif modo NEQ 'ALTA'>
						        <cfset LvarTotalPagado = rsFPagos3.FPagoDoc - LvarVuelto >
							<cfelse>
							    <cfset LvarTotalPagado = 0.00>
						    </cfif>
			          		<input name="ETtotalPagado" type="text" style="text-align:right;"
								   onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
						           value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(LvarTotalPagado,'none')#<cfelse>0.00</cfif>"
						           size="18" maxlength="18">
			        	</cfoutput>
			        </td>
				</tr>        --->
                <cfif modo NEQ "ALTA" and LvarVuelto gt 0>
                <!-----Vuelto en efectivo ---->
                    <tr>
                        <td nowrap align="right">
                            <label id="vuelto">Cambio:</label>
                        </td>
                        <td colspan="2">

                            <cfoutput>


                                <input name="vuelto" type="text" style="text-align:right;"
                                       onChange="javascript: fm(this,2);" class="" readonly tabindex="-1"
                                       value="<cfif modo NEQ 'ALTA'>#LSCurrencyFormat(LvarVuelto,'none')#<cfelse>0.00</cfif>"
                                       size="18" maxlength="18">
                            </cfoutput>

                        </td>
                    </tr>
                </cfif>
            </div>
        	</cfoutput>
        	</div>
			<!--- </table> --->
			</td>
		</tr>
		<!--- HIddens y ts_rversion y OTROS QUERIES --->
		<tr>
			<cfoutput>
				<td colspan="6">
					<input type="hidden" name="ETfecha"
						   value="<cfif modo NEQ "ALTA">#LSDateFormat(rsTransaccion.ETfecha,'DD/MM/YYYY')# #LSTimeFormat(rsTransaccion.ETfecha, 'HH:mm:ss')#<cfelse>#LSDateFormat(Now(),'DD/MM/YYYY')# #LSTimeFormat(now(), 'HH:mm:ss')#</cfif>">
		            <input type="hidden" name="ETestado" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETestado#<cfelse>P</cfif>">
		            <input type="hidden" name="ETnumext" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETnumext#</cfif>">
		            <input type="hidden" name="ETnumero" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETnumero#</cfif>">
		            <input type="hidden" name="Tid" value="<cfif modo NEQ "ALTA">#rsTransaccion.Tid#</cfif>">
		            <input type="hidden" name="ETserie" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETserie#</cfif>">
		            <input type="hidden" name="ETdocumento" value="<cfif modo NEQ "ALTA">#rsTransaccion.ETdocumento#</cfif>">
		            <input type="hidden" name="LPid" value="">
				    <input type="hidden" name="Cambio" value="">
				    <cfif modo NEQ 'ALTA'>
				    	<input type="hidden" name="sumaPagos" value="<cfif rsPagos.RecordCount GT 0>#rsPagos.sumFPmontolocal#<cfelse>0</cfif>">
				  	</cfif>
				  	<!--- ts_rversion --->
		            <cfset tsE = "">
		            <cfif modo neq "ALTA">
			            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsE">
			            	<cfinvokeargument name="arTimeStamp" value="#rsTransaccion.ts_rversion#"/>
		            	</cfinvoke>
		          	</cfif>
		          	<input type="hidden" name="timestampE" value="<cfif modo NEQ 'ALTA'><cfoutput>#tsE#</cfoutput></cfif>">
				</td>
				<cfif rsTiposTransaccion.RecordCount GT 0>
					<script language="JavaScript1.2">
						TraerTransaccion(document.form1.CCTcodigo.value);
						TraerTalonario(document.form1.Tid.value);
					</script>
				</cfif>
				<cfif isDefined('form.LiquidacionRuteros')> <!--- Sea por primera vez, o proveniente del SQLTransaccionesFA.cfm --->
					<input type="hidden" name="LiquidacionRuteros" value="LiquidacionRuteros"/>
					<input type="hidden" name="FALIid" value="<cfoutput>#form.FALIid#</cfoutput>"/>
				</cfif>
			</cfoutput>
		</tr>
	</table>
</div>
</cffunction>



<!--- Pinta la lista de detalles --->
<cffunction name="PintaListaDetalles">
	<div class="contenido">
	<table border="0" bordercolor="red" cellpadding="0" cellspacing="0" width="100%">
			<cfif modo NEQ 'ALTA'>
				<cfset rsListaDetalles()>
				<tr>
					<td colspan="6">
				 		<table width="98%" style="margin:0;padding:0" cellspacing="1" cellpadding="1">
					        <tr>
						        <td class="subTitulo">
									<!--- registro seleccionado --->
									<cfif isDefined("DTlinea") and Len(Trim(DTlinea)) GT 0 >
										<cfset seleccionado = DTlinea ><cfelse><cfset seleccionado = "" >
									</cfif>
								    <form action="OrdenCM.cfm" method="post" name="form2">
								    	<cfif isDefined('form.LiquidacionRuteros')> <!--- Sea por primera vez, o proveniente del SQLTransaccionesFA.cfm --->
											<input type="hidden" name="LiquidacionRuteros" value="LiquidacionRuteros"/>
											<input type="hidden" name="FALIid" value="<cfoutput>#form.FALIid#</cfoutput>"/>
										</cfif>
						                <input name="datos" type="hidden" value="">
						                <input type="hidden" name="FAction" value=""/>
						              	<table id="tbLineas" width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-left:10px">
						                	<tr class="tituloListas">
						                	<cfoutput>
						                    	<th>&nbsp;</th>
						                  		<th><div align="left"><strong>&nbsp;L&iacute;nea</strong></div></th>
							                  	<th><strong>Descripción</strong></th>
							                  	<td align="center"><strong>Tipo</strong></th>
							                  	<th> <div align="right"><strong>Cantidad</strong></div></th>
							                  	<th> <div align="right"><strong><cfif moduloOrigen eq "CRC">Abono<cfelse>Precio Unitario</cfif></strong></div></th>
					                  			<cfif moduloOrigen neq "CRC">
					                  				<th><div align="right"><strong>Impuesto</strong></div></th>
					                  			</cfif>
									  			<th><div align="right"><strong>Descuento</strong></div></th>
									  			<cfif moduloOrigen neq "CRC">
										  			<th><div align="right"><strong>Comisión</strong></div></th>
						                  			<th><div align="right"><strong>Recargo</strong></div></th>
						                  		</cfif>
					                  			<th><div align="center"><strong>Pago</strong></div></th>
					                  			<th>&nbsp;</th>
					                  			<th>&nbsp;</th>
					                  		</cfoutput>
						                	</tr>
						                	<cfoutput query="rsLineas">
										  		<tr <cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
												  			onMouseOver="style.backgroundColor='##E4E8F3';"
												  			onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
						                    		<td align="left">
						                    			<cfif modoDet NEQ 'ALTA' and rsLineas.DTlinea EQ seleccionado>
						                    				<img src="/cfmx/sif/imagenes/addressGo.gif" height="12" width="12" border="0">
						                    			</cfif>
						                    		</td>
						                    		<td align="left">#rsLineas.CurrentRow#</td>
								                    <td>#rsLineas.descripcion#</td>
								                    <td align="center">#rsLineas.DTtipo#</td>
								                    <td><div align="right">#LSCurrencyFormat(rsLineas.DTcant,'none')#</div></td>
								                    <td><div align="right">#LSCurrencyFormat(rsLineas.DTpreciou,'none')#</div></td>
								                    <cfif moduloOrigen neq "CRC">
														<td><div align="right">#LSCurrencyFormat(rsLineas.DTimpuesto,'none')#</div></td>
													</cfif>
								                    <td><div align="right">#LSCurrencyFormat(rsLineas.DTdeslinea,'none')#</div></td>
								                    <cfif moduloOrigen neq "CRC">
									                    <td><div align="right">
								                    		<cfif rsLineas.ProntoPagoClienteCheck eq 1>
								                    			#LSCurrencyFormat(rsLineas.ProntoPagoCliente,'none')#
								                    		<cfelse>0.00</cfif>
									                    </div></td>
									                    <td><div align="right">#LSCurrencyFormat(rsLineas.DTreclinea,'none')#</div></td>
									                </cfif>
						                    		<td>
						                    			<div align="right">#LSCurrencyFormat(rsLineas.DTtotal,'none')#</div>
						                    		</td>
						                    		<td align="center">&nbsp;
							                    		<!--- SE COMENTA DE FORMA TEMPORAL 31 10 2016 --->
								                    	<!--- <cfif rsLineas.Cid gt 0>
								                    		<img border="0"
								                    			 onclick="javascript:doConlisVariables(#rsLineas.Cid#, #rsLineas.DTlinea#, '#rsLineas.descripcion#')"
								                    			 onMouseOver="style.cursor='pointer';"
								                    			 title="Agregar Datos Variables"
								                    			 src="/cfmx/sif/imagenes/stop2.gif">
														<cfelse>
															--
														</cfif> --->
													</td>
													<cfif moduloOrigen neq "CRC">
							                    		<td align="center">&nbsp;
							                    			<img border="0"
								                    			onclick="javascript:Editar('#rsLineas.FCid#|#rsLineas.ETnumero#|#rsLineas.DTlinea#');"
								                    			onMouseOver="style.cursor='pointer';"
								                    			title="Editar Línea"
								                    			src="/cfmx/sif/imagenes/edit_o.gif">
							                    		</td>
							                    	<cfelse>
														<td align="center">&nbsp;
															<cfif rsTransaccion.ETestado eq 'P'>
																<img border="0"
																	onclick="javascript:if(confirm('Desa eliminar el registro?')) EliminarLineaCRC('#rsLineas.FCid#|#rsLineas.ETnumero#|#rsLineas.DTlinea#');"
																	onMouseOver="style.cursor='pointer';"
																	title="Eliminar Línea"
																	src="/cfmx/sif/imagenes/deleteicon.gif">
															</cfif>
							                    		</td>
							                    	</cfif>
						                  		</tr>
						                	</cfoutput>
							                <cfif rsLineas.RecordCount GT 0>
							                    <cfoutput>
							                    <tr class="tituloListas">
							                      	<td width="3%" bgcolor="E2E2E2">&nbsp;</td>
							                        <td bgcolor="E2E2E2"><strong>&nbsp;</strong></td>
							                      	<td bgcolor="E2E2E2"><strong>&nbsp;</strong></td>
							                        <td bgcolor="E2E2E2"><strong>&nbsp;</strong></td>
							                      	<td bgcolor="E2E2E2"> <div align="right"><strong>&nbsp;</strong></div></td>
							                      	<td bgcolor="E2E2E2"> <div align="right"><strong>&nbsp;</strong></div></td>
							                      	<td bgcolor="E2E2E2"> <div align="right"><strong>&nbsp;</strong></div></td>
							                      	<td bgcolor="E2E2E2"> <div align="right"><strong>&nbsp;</strong></div></td>
							                      	<td bgcolor="E2E2E2" colspan="2"><div align="right"><strong>SubTotal:</strong></div></td>
							                      	<td bgcolor="E2E2E2"> <div align="right"><strong>#LSCurrencyFormat(rsTotal.total,'none')#</strong></div></td>
							                    </tr>
							                    </cfoutput>
												<cfif isdefined('moduloOrigen') && moduloOrigen eq 'CRC'>
													<script>
														document.getElementById('divNuevoDet').style.display = 'none';
													</script>
												</cfif>
											<cfelse>
											    <tr>
													<td colspan="10">
														<div align="center">
															<strong>--- No hay datos ---</strong>
															<cfif isdefined('moduloOrigen') && moduloOrigen eq 'CRC'>
																<script>
																	document.getElementById('divNuevoDet').style.display = 'inline';
																</script>
															</cfif>
														</div>
													</td>
											  	</tr>
							                </cfif>
							            </table>
							        </form>
		             			</td>
		        			</tr>
		        		</table>
					</td>
				</tr>
			</cfif>
	</table>
	</div>
</cffunction>

<cffunction name="PintaCamposModDetalle">
	<cfset queriesModDetalle()>
	<!--- Detalles Cambio --->
	<cfif modoDet EQ 'ALTA'>
		<cfset titleDialog ="Agregando Nueva linea...">
	<cfelse>
		<cfset titleDialog = "Modificando línea existente...">
	</cfif>
	<cfif moduloOrigen eq "CRC">
		<cfinclude template="/crc/cobros/operacion/TransaccionesCRC_Det.cfm">
	<cfelse>
		<cf_Confirm width="92" index="1" title="#titleDialog#" botones="Cancelar">
		 	<div id="detallesDiv">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr>
						<td colspan="4" style="text-align:right">
							<cfif isDefined('rsLinea.DTExterna') and rsLinea.DTExterna EQ 'S'>
								<label class="etiqueta colorAzul">
									Línea Recuperada de un sistema externo (<label class="etiqueta" style="color:red">No modificable</label>)
								</label>
							</cfif>
						</td>
			  		</tr>
					<tr>
						<td class='panelIzquierdo'>
							<table border="0" cellpadding="1" cellspacing="0" style="width:100%">
								<!------------------------------------------------------------------------------------->
								<!--- Item, Centro Funcional --->
								<!------------------------------------------------------------------------------------->
								<tr>
									<!--- Item --->
									<td align="right">
										<label id="itemLabel" class="etiqueta">Item:</label>
									</td>
									<td>
										<select name="Item" onChange="javascript:limpiarDetalle();cambiarDetalle();" tabindex="2">
							            <cfif rscArticulos.cant GT 0>
							            	<option value="A"
							            			<cfif modoDet NEQ "ALTA" and trim(rsLinea.DTtipo) EQ "A"> selected
							            			<cfelseif modoDet EQ "ALTA" and isdefined('rsProducto.FCtipodef') and len(trim(#rsProducto.FCtipodef#)) gt 0 and #rsProducto.FCtipodef# eq 'A'>selected</cfif>>Art&iacute;culo
							            	</option>
							            </cfif>
							            <cfif rscConceptos.cant GT 0>
							              <option value="S"
							              		  <cfif modoDet NEQ "ALTA" and trim(rsLinea.DTtipo) EQ "S"> selected
							              		  <cfelseif modoDet EQ "ALTA" and  isdefined('rsProducto.FCtipodef')
							              		  	and len(trim(#rsProducto.FCtipodef#)) gt 0 and #rsProducto.FCtipodef# eq 'S'>selected
							              		  </cfif>>Conceptos
							              	</option>
							            </cfif>
							          </select>
									</td>
									<!--- Centro funcional --->
									<td align="right">
										<label class="etiqueta">Centro Funcional:</label>
									</td>
									<td>
										<cfset valuesArrayCF = ArrayNew(1)>
										<cfif isdefined("rsLinea.CFid") and len(trim(rsLinea.CFid))>
											<cfquery datasource="#Session.DSN#" name="rsSN">
												select
												CFid,
												CFcodigo,
												CFdescripcion
												from CFuncional
												where Ecodigo = #session.Ecodigo#
												and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.CFid#">
											</cfquery>

											<cfset ArrayAppend(valuesArrayCF, rsSN.CFid)>
											<cfset ArrayAppend(valuesArrayCF, rsSN.CFcodigo)>
											<cfset ArrayAppend(valuesArrayCF, rsSN.CFdescripcion)>

										</cfif>
										<cf_conlis
											Campos="CFidD,CFcodigoD,CFdescripcionD"
											valuesArray="#valuesArrayCF#"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,20"
											tabindex="5"
											Title="Lista de Centros Funcionales"
											Tabla="CFuncional cf
											inner join Oficinas o
											on o.Ecodigo=cf.Ecodigo
											and o.Ocodigo=cf.Ocodigo"
											Columnas="distinct cf.CFid as CFidD,cf.CFcodigo as CFcodigoD  ,cf.CFdescripcion #LvarCNCT# ' (Oficina: ' #LvarCNCT# rtrim(o.Oficodigo) #LvarCNCT# ')' as CFdescripcionD"
											Filtro=" cf.Ecodigo = #Session.Ecodigo# order by cf.CFcodigo"
											Desplegar="CFcodigoD,CFdescripcionD"
											Etiquetas="Codigo,Descripcion"
											filtrar_por="cf.CFcodigo,CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											form="form1"
											Asignar="CFidD,CFcodigoD,CFdescripcionD"
											traerinicial="true"
								            traerfiltro="CFcodigo = 'E007-4'"
											Asignarformatos="S,S,S,S"
										/>
									</td>
								</tr>
								<!------------------------------------------------------------------------------------->
								<!--- Concepto, ALmacen, Servicio --->
								<!------------------------------------------------------------------------------------->
								<tr>
									<!--- Almacen --->
									<td align="right">
										<label id="AlmacenLabel" class="etiqueta">Almacén:</label>
									</td>
									<td>
										<select name="Almacen" onChange="javascript:limpiarAxCombo();"
										        			   tabindex="2" <cfif rsCajas.FCalmmodif neq 1> disabled="disabled" </cfif> >
							            	<cfoutput query="rsAlmacenes">
							            		<option value="#rsAlmacenes.Alm_Aid#" <cfif modoDet NEQ "ALTA"
							            		        and rsAlmacenes.Alm_Aid EQ rsLinea.Alm_Aid>selected</cfif>>#rsAlmacenes.Bdescripcion#
							            		</option>
							            	</cfoutput>
							            </select>
									</td>
									<!---  Concepto o servicio --->
									<td align="right">
	         							<input name="DetalleItem" type="text" class="TextoNegrita"
	         								   tabindex="-1" value="Artículo" size="6" style="border:none">
	         						</td>
	         						<td nowrap>
	        							<input name="descripcion" type="text" tabindex="-1" style="display:inline"
											   value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsLinea.DTdescripcion)#</cfoutput></cfif>" size="37" maxlength="1000" readonly>
	         							<a href="#" style="display:inline" tabindex="-1"><img id="imgArticulo" src="../../imagenes/Description.gif"
	         							             alt="Lista" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisItem();">
	         							</a>
	         						</td>
								</tr>
								<!------------------------------------------------------------------------------------->
								<!---- Impuesto,Vendedor--->
								<!------------------------------------------------------------------------------------->
								<tr>
									<!--- Impuesto --->
									<td align="right">
										 <label id="ImpuestoLabel" class="etiqueta">Impuesto:</label>
									</td>
									<td>
								        <cfif modoDet NEQ "ALTA" and isdefined('rsLinea') and len(trim(rsLinea.Idescripcion)) gt 0>
								           <cfset LvarIdesc = #rsLinea.Idescripcion#>
								           <cfset LvarIcod = #rsLinea.Icodigo#>
								       <cfelse>
								           <cfset LvarIdesc = "">
								           <cfset LvarIcod = "">
								        </cfif>
								          <input type="hidden" name="Icodigo" id="Icodigo" value="<cfoutput>#LvarIcod#</cfoutput>"/>
								          <input type="text" disabled="disabled"  size="30" id="Idescripcion" name="Idescripcion" value="<cfoutput>#LvarIdesc#</cfoutput>"  size="40" />
								    </td>
								    <!--- Vendedor --->
								    <td align="right">
								    	<label id="VendoLabel" class="etiqueta">Vendedor:</label>
								    </td>
								    <td>
								    	<select name="FVid" tabindex="1">
	                                    <option value="">--Seleccione ---</option>
								            <cfoutput query="rsVendedores">
								                <option value="#rsVendedores.FVid#"
								              	      <cfif modoDet NEQ 'ALTA' and rsVendedores.FVid EQ rsLinea.FVid>selected
								              		  <cfelseif modoDet EQ 'ALTA' and rsVendedores.Usucodigo EQ session.Usucodigo>selected</cfif>>
								              		  #rsVendedores.FVnombre#
								                </option>
								            </cfoutput>
							        	</select>
							        </td>
								</tr>
								<!------------------------------------------------------------------------------------->
								<!---- Descripcion, Descripcion Alterna--->
								<!------------------------------------------------------------------------------------->
								<tr>
									<!--- Descripcion --->
									<td align="right">
										<label id="DescripcionLabel" class="etiqueta">Descripción:</label>
									</td>
	        						<td>
	        							<input name="DTdescripcion" tabindex="2"
	        								   onFocus="javascript:document.form1.DTdescripcion.select();" type="text"
	        								   value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsLinea.DTdescripcion)#</cfoutput></cfif>" size="40" maxlength="255">
	        						</td>
	        						<!--- Descripcion alterna --->
	        						<td align="right">
	        							<label id="descAltLabel" class="etiqueta">Desc. Alterna:</label>
	        						</td>
	        						<td>
	        							<input name="DTdescalterna" tabindex="2"
	        							       onFocus="javascript:document.form1.DTdescalterna.select();" type="text"
	        							       value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsLinea.DTdescalterna)#</cfoutput></cfif>" size="30" maxlength="255">
	          						</td>
								</tr>
								<!------------------------------------------------------------------------------------->
								<!---- Departamento, Actividad Empresarial--->
								<!------------------------------------------------------------------------------------->
								<tr>
									<!--- Departamento --->
									<td align="right">
										<label id="DepLabel" class="etiqueta">Departamento:</label>
									</td>
									<td>
										<select name="Dcodigo" tabindex="2"
										        onChange="javascript: TraerCuentaConcepto(document.form1.Cid.value,this.value);">
							            	<cfoutput query="rsDepartamentos">
							                	<option value="#rsDepartamentos.Dcodigo#"
							                	        <cfif modoDet NEQ "ALTA" and rsDepartamentos.Dcodigo EQ rsLinea.Dcodigo>selected</cfif>>
							                	        #rsDepartamentos.Ddescripcion#
							                	</option>
							            	</cfoutput>
										</select>
									</td>
									<!--- Actividad Empresarial --->
									<cfif validaActividadEmpresarial.Pvalor EQ 'S'>
										<td align="right">
											<label id="ActEmLabel" class="etiqueta">Actividad Empresarial:</label>
										</td>
									</cfif>
						            <cfset idActividad = "">
									<cfset valores = "">
						            <cfset lvarReadonly = false>
						            <cfif modoDet NEQ "ALTA">
						            	<cfset idActividad = rsLinea.FPAEid>
						                <cfset valores = rsLinea.CFComplemento>
						                <cfset lvarReadonly = false>
						            </cfif>

									<!--- <cfdump var="#rsLinea#">
						            <cfdump var="#idActividad#">
						            <cfdump var="#valores#">
						            <cfdump var="#LvarReadonly#">
						            <cf_dump var="break"> --->

						        	<td valign="top">
						        		<cf_ActividadEmpresa etiqueta="" idActividad="#idActividad#"
						        		                     valores="#valores#" name="CFComplemento" nameId="FPAEid" formname="form1"
						        		                     readonly="#lvarReadonly#">
						        	</td>
								</tr>
	                            <!-----CODempresa --CODproducto ****** OPCIONAL ****** ------>
								<cfif rsManejaEgresos.Pvalor eq 1 >
	                            <tr>
	                              <td align="right"><label id="CodEmpresaLbl" class="etiqueta">Codigo Empresa:</label></td>
	                              <td valign="top">
	                            <!---  <input type="text" maxlength="5"  name="CodEmpresa" id="CodEmpresa"  tabindex="-1" value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsLinea.codEmpresa)#</cfoutput></cfif>" />--->
	                               <cfquery name="rsEmpresas" datasource="#session.dsn#">
	                                  Select distinct COMRcodEmpresa
	                                  From COMRestriccionesGeneral
	                                  Where Ecodigo = #session.Ecodigo#
	                                </cfquery>
	                                <select name="CodEmpresa" id="CodEmpresa" tabindex="5">
	                                <option value="">--Seleccione--</option>
	                                    <cfoutput query="rsEmpresas">
	                                      <option value="#trim(rsEmpresas.COMRcodEmpresa)#" <cfif modoDet NEQ "ALTA" and trim(rsLinea.codEmpresa) eq trim(rsEmpresas.COMRcodEmpresa)> selected </cfif> >
	                                        #rsEmpresas.COMRcodEmpresa#
	                                      </option>
	                                    </cfoutput>
	                                </select>
	                              </td>
	                            </tr>
	                            <tr>
	                              <td align="right"><label id="CodProductoLbl" class="etiqueta">Codigo Producto:</label></td>
	                              <td valign="top">
	                              <!---<input type="text" maxlength="5"  name="CodProducto" id="CodProducto"  tabindex="-1" value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsLinea.codProducto)#</cfoutput></cfif>" />--->
	                               <cfquery name="rsProducto" datasource="#session.dsn#">
	                                  Select distinct COMRcodProducto
	                                  From COMRestriccionesGeneral
	                                  Where Ecodigo = #session.Ecodigo#
	                                </cfquery>
	                                <select name="CodProducto" id="CodProducto" tabindex="5"  >
	                                <option value="">--- Seleccione ----</option>
	                                    <cfoutput query="rsProducto">
	                                      <option value="#trim(rsProducto.COMRcodProducto)#" <cfif modoDet NEQ "ALTA" and trim(rsLinea.codProducto) eq  trim(rsProducto.COMRcodProducto)> selected </cfif>>
	                                        #rsProducto.COMRcodProducto#
	                                      </option>
	                                    </cfoutput>
	                                </select>
	                              </td>
	                            </tr>
	                            </cfif>
							</table>
						</td>


						<!--- MONTOS --->


						<td class="panelDerecho">
							<table border="0" cellpadding="1" cellspacing="0">
								<!--- Precio Unitario --->
								<tr>
									<td align="right">
										<label id="PrecioULabel" class="etiqueta">Precio Unitario:</label>
									</td>
	        						<td>
	        							<input name="DTpreciou" onkeypress="javascript: disable();"
	        								   onBlur="javascript: suma();" onFocus="javascript:document.form1.DTpreciou.select();"
	        								   type="text" tabindex="3" style="text-align:right"
	        								   onChange="javascript:fm(this,2);suma();" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTpreciou,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18">
	        						</td>
								</tr>
								<!--- Cantidad --->
								<tr>
									<td align="right">
										<label id="cantLabel" class="etiqueta">Cantidad:</label>
									</td>
	        						<td>
	        							<input name="DTcant"
	        							       onBlur="javascript:suma();"
	        							       onFocus="javascript:document.form1.DTcant.select();"
	        							       type="text" tabindex="3" style="text-align:right"
	        							       onChange="javascript:fm(this,2);suma();"
	        							       value="<cfif modoDet NEQ "ALTA">
	        							             <cfoutput>#LSCurrencyFormat(rsLinea.DTcant,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
	        							       size="18" maxlength="18">
	                                </td>
								</tr>
								<tr>
								<!--- Descuento --->
									<td align="right">
										<label id="descLabel" class="etiqueta">Descuento:</label>
									</td>
							       <!--- <td><input name="DTdeslinea" onBlur="javascript: suma();" onFocus="javascript: this.select();" type="text" tabindex="3" style="text-align:right" onChange="javascript:fm(this,2);suma();" value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTdeslinea,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18">
									</td>--->
									<td>
										<input name="DTdeslinea"  type="text" tabindex="3"
										       style="text-align:right" onchange="javascript: fm(this,2);suma2();"
										       value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTdeslinea,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18">
									</td>
	      							<input type="hidden" name="Desc" value="" />
								</tr>
								<!--- Recargo --->
								<tr>
									<td align="right">
										<label id="recargoLabel" class="etiqueta">Recargo:</label>
									</td>
	        						<td>
	        							<input name="DTrecargo" type="text" style="text-align:right; margin-top: 7px;"
	        								   onBlur="javascript: suma();" onFocus="javascript: this.select();"
	        								   onchange="javascript:fm(this,2); suma();" tabindex="-1"
	        								   value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTreclinea,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18">
	        							<input type="hidden" name="rec" value="" />
	        						</td>
								</tr>
								<!--------------------------------------------------------------------------------------------------------------------------->
								<!--- TOTAL --->
								<!--------------------------------------------------------------------------------------------------------------------------->
								<tr>
									<td align="right">
										<label class="etiqueta" class="totGen OtrosTotales">Total:</label>
									</td>
	        						<td>
	        							<input name="DTtotal" type="text" class=""
	        							       style="text-align:right;border:0" onchange="javascript:fm(this,2);" tabindex="-1"
	        							       value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DTtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="18" maxlength="18" readonly>
	        						</td>
								</tr>
							</table>
						</td>
					</tr>
					<!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones --->
					<!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones --->
					<!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones ---><!--- Botones --->
				    <tr>
				        <td colspan="2" align="center">
						    <cfif rsTransaccion.ETestado NEQ "T">
				            	<cfif modoDet EQ "ALTA">
				              		<input name="AgregarD" tabindex="3" type="submit" class="btnGuardar" value="Agregar"
							  		       onclick="javascript: return prepararDatos();">
				            	<cfelse>
				            		<cfif isDefined('rsLinea.DTExterna') and  rsLinea.DTExterna NEQ 'S'>
				            			<input name="CambiarD" tabindex="3" type="submit"
				            			 	   class="btnGuardar" value="Modificar"
				            			 	   onClick="javascript: return prepararDatos();">
				            		</cfif>
								  	<input name="BorrarD" class="btnEliminar"
								  		   tabindex="3" type="submit" value="Borrar Linea"
								  		   onclick="javascript:if (confirm('¿Desea borrar esta línea del documento? \n En caso de ser una linea externa, será devuelta a la lista de recuperaración.')) return true; else return false;">

								</cfif>
				  		    </cfif>
				        </td>
				    </tr>
				</table>
				<!--- HIDDENS --->
				<cfoutput>
		            <input name="Cid" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Cid#</cfif>">
		            <input name="Aid" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Aid#</cfif>">
		            <input name="DTtipo" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTtipo#</cfif>">
		            <input name="DTfecha" type="hidden" value="<cfif modoDet NEQ "ALTA">#LSDateFormat(rsLinea.DTfecha,'DD/MM/YYYY')#<cfelse>#LSDateFormat(Now(),'DD/MM/YYYY')#</cfif>">
		            <input name="DTlinea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTlinea#</cfif>">
		            <input name="CcuentaDet" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Ccuenta#</cfif>">
		            <input name="CcuentadesDet" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Ccuentades#</cfif>">
		            <input name="DTlineaext" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTlineaext#</cfif>">
		            <input name="DTcodigoext" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DTcodigoext#</cfif>">
		            <input name="ModPrecio" type="hidden" value="1">
		            <input name="CambioEncabezado" type="hidden" value="">
		            <!--- ts_rversion del Detalle --->
		            <cfset tsD = "">
		            <cfif modoDet NEQ "ALTA">
		              <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD">
		              </cfinvoke>
		            </cfif>
		            <input name="timestampD" type="hidden" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>">
	          </cfoutput>
		 	</div>
		</cf_Confirm>

	</cfif>

	 <!--- fin campos cambio detalle --->

	<!--- Solo abrimos el detalle en edicion o para agregar un nuevo detalle cuando se presiono el boton, la primera vez no --->

	<cfif modoDet EQ 'CAMBIO' or isDefined('form.NuevoDet')>
		<script>PopUpAbrir1()</script>
	</cfif>

</cffunction>


<cffunction name="rsListaDetalles">
	<!--- Lista de lineas --->
    <cfquery name="rsLineas" datasource="#Session.DSN#">
        select
		 	convert(varchar,a.FCid) as FCid,
			convert(varchar,a.DTlinea) as DTlinea,
			a.ETnumero,
			a.DTpreciou,
        	a.DTcant,
			a.DTdeslinea,
            a.DTreclinea,
			a.DTtotal,
            a.DTtipo,
			a.ts_rversion,
			convert(varchar,a.Aid) as Aid,
			convert(varchar,a.Cid) as Cid,
			case when c.Cid is null and a.Aid is null then a.DTdescripcion
				when c.Cid is null then a.DTdescripcion
				when a.Aid is null then c.Cdescripcion
			else '' end as descripcion2,
			a.DTdescripcion as descripcion,
			a.DTimpuesto,
			ProntoPagoCliente,
            ProntoPagoClienteCheck
		FROM DTransacciones a
		     INNER JOIN ETransacciones b
			 ON a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		     AND a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero#">
		     AND a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#">
		     AND a.DTborrado = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
			 AND a.Ecodigo = b.Ecodigo
			 AND a.ETnumero = b.ETnumero
			 AND a.FCid = b.FCid
			 LEFT OUTER JOIN
		     Conceptos c
			 ON a.Ecodigo = c.Ecodigo
		     AND a.Cid = c.Cid
			 LEFT OUTER JOIN
			 Articulos d
			 ON a.Ecodigo = d.Ecodigo
		     AND a.Aid = d.Aid
		ORDER BY a.DTlinea
    </cfquery>

    <!--- Sumatoria total de las lineas --->
    <cfquery name="rsTotal" dbtype="query">
    	select sum(DTtotal) as total from rsLineas
    </cfquery>
</cffunction>


<cffunction name="queriesModDetalle">
	<cfquery name="rsProducto" datasource="#session.dsn#">
    	select FCtipodef from FCajas  where Ecodigo = #session.Ecodigo# and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid#" >
    </cfquery>
</cffunction>

<cfif moduloOrigen eq "CRC">
<!--- scripts para detalles de productos de credito --->
<script>
	$('#crcCuenta').on('change', function()
	{
	   var cuentaid = this.value;

		$.ajax({
	   		type: "POST",
			url: "/cfmx/crc/Componentes/CRCCuentas.cfc?method=getPagos",
			data: {idcuenta:cuentaid},
	   		success: function(result){
	        	$("#divPagar").html(result);
	    	}
	   	});
	});
</script>

</cfif>
