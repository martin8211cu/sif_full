<cfinclude template="../../../Utiles/sifConcat.cfm">


<cf_web_portlet_start titulo="NAPs por Cuenta">
<!--- PARAMS --->
<cfparam name="form.txtDocument" default="">
<cfparam name="form.txtReferencia" default="">
<cfparam name="form.txtDesdeNap" default="">
<cfparam name="form.txtHastaNap" default="">
<cfparam name="form.FechaOriD" default="">
<cfparam name="form.FechaOriH" default="">
<cfparam name="form.FechaNapD" default="">
<cfparam name="form.FechaNapH" default="">
<cfparam name="form.btnFiltrar" default="">

<!--- QUERY ORIGENES --->
<cfquery name="rsORigenes" datasource="#Session.DSN#">
		select Oorigen,Odescripcion from Origenes
</cfquery>

<!--- QUERY MODULOS --->
<cfquery name="rsModulos" datasource="#Session.DSN#">
	select Oorigen, Odescripcion from Origenes
</cfquery>

<cfparam name="form.CPPid" default="">
<cfparam name="form.CtaPres" default="">
<cfif isdefined("url.CtaPres")>
	<cfset form.CtaPres=url.CtaPres>
</cfif>
<cfif isdefined("url.CPPid")>
	<cfset form.CPPid=url.CPPid>
</cfif>
<cfif isdefined("url.txtDesdeNap")>
	<cfset form.txtDesdeNap=url.txtDesdeNap>
</cfif>
<cfif isdefined("url.txtHastaNap")>
	<cfset form.txtHastaNap=url.txtHastaNap>
</cfif>
<cfif isdefined("url.FechaNapD")>
	<cfset form.FechaNapD=url.FechaNapD>
</cfif>
<cfif isdefined("url.FechaNapH")>
	<cfset form.FechaNapH=url.FechaNapH>
</cfif>
<cfif isdefined("url.FechaOriD")>
	<cfset form.FechaOriD=url.FechaOriD>
</cfif>
<cfif isdefined("url.FechaOriH")>
	<cfset form.FechaOriH=url.FechaOriH>
</cfif>
<cfif isdefined("url.txtDocument")>
	<cfset form.txtDocument=url.txtDocument>
</cfif>
<cfif isdefined("url.txtReferencia")>
	<cfset form.txtReferencia=url.txtReferencia>
</cfif>
<cfif isdefined("url.txtReferencia")>
	<cfset form.LModulos=url.LModulos>
</cfif>




<!---                                           FILTROS                                      --->
<cfoutput>
<form name="form1" style="margin:0;" method="post" action="#GetFileFromPath(GetTemplatePath())#" onSubmit="return sbSubmit();">
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
		<!--- FILA UNO --->
		<tr>
			<!--- CUENTA --->
			<td align="right">
				<strong>Cuenta:</strong>&nbsp;
			</td>

			<td colspan="3">

				<cf_CuentaPresupuesto name="CtaPres" value="#form.CtaPres#" size="51">
				<cfset session.CtaPres = form.CtaPres>
			</td>
			<!--- MODULO --->
			<td nowrap align="right">
				<strong>M&oacute;dulo:</strong>&nbsp;
			</td>
			<td nowrap colspan="3">
				<select name="LModulos" id="select">
					<option value="" selected>(Todos los M&oacute;dulos...)</option>
				<cfloop query="rsModulos">
					<option value="#trim(rsModulos.Oorigen)#"
					<cfif isdefined('form.LModulos') and (trim(rsModulos.Oorigen) EQ trim(form.LModulos))>selected</cfif>>
					#HTMLEditFormat(rsModulos.Oorigen)# - #HTMLEditFormat(rsModulos.Odescripcion)#</option>
				</cfloop>
				</select>
			</td>
		</tr>
		<!--- FILA DOS --->
		<tr>
			<!--- PERIODO --->
			<td nowrap align="right">
				<strong>Per&iacute;odo:</strong>&nbsp;
			</td>
			<td colspan="3">

				<cf_cboCPPid incluirTodos="true" value="#form.CPPid#" CPPestado="1,2">
				<cfset session.CPPid = form.CPPid>
			</td>
			<!--- DOCUMENTO --->
			<td nowrap align="right">
				<strong>Documento:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="txtDocument" id="txtDocument" size="15"
						value="#form.txtDocument#">
			</td>
			<!--- REFERENCIA --->
			<td nowrap align="right">
				<strong>Referencia:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="txtReferencia" id="txtReferencia" size="15"
						value="#form.txtReferencia#">
			</td>
		</tr>
		<!--- FILA TRES --->
		<tr>
			<!--- DESDE NAP --->
			<td nowrap align="right">
				<strong>Desde NAP:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="txtDesdeNap" id="txtDesdeNap" size="15"
						value="#form.txtDesdeNap#">
			</td>
			<!--- HASTA NAP--->
			<td nowrap align="right">
				 <strong>Hasta NAP:</strong>&nbsp;
			</td>
			<td nowrap>
				<input 	name="txtHastaNap" id="txtHastaNap" size="15"
				  		value="#form.txtHastaNap#">
			</td>
			<!--- DESDE FECHA DOCUMENTO --->
			<td nowrap align="right">
				<strong>Desde Fecha Doc:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaOriD')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriD" value="#form.FechaOriD#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriD" value="">
				</cfif>
			</td>
			<!--- HASTA FECHA --->
			<td nowrap align="right">
				<strong>Hasta Fecha:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaOriH')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriH" value="#form.FechaOriH#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaOriH" value="">
				</cfif>
			</td>
		</tr>
		<!--- FILA CUATRO --->
		<tr>
			<!--- DESDE FECHA NAP --->
			<td nowrap align="right">
				<strong>Desde Fecha NAP:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaNapD')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapD" value="#form.FechaNapD#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapD" value="">
				</cfif>
			</td>
			<!--- HASTA FECHA NAP --->
			<td nowrap align="right">
				<strong>Hasta Fecha:</strong>&nbsp;
			</td>
			<td nowrap>
				<cfif isdefined('form.FechaNapH')>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapH" value="#form.FechaNapH#">
				<cfelse>
					<cf_sifcalendario conexion="#session.DSN#" form="form1" name="FechaNapH" value="">
				</cfif>
			</td>
			<td colspan="4" nowrap align="right">
				<input name="btnFiltrar" type="button" onclick="validateData()" value="Filtrar">
				<input name="btnPrint" type="button" onclick="printReport()" value="Imprimir">
			</td>
		</tr>
	</table>
</form>


<!---                   ************     CONSULTA DE REPORTE         ************           --->

<cfif isDefined("form.CPPid") AND  #form.CPPid# NEQ -1 AND #form.CPPid# NEQ ""
  AND isDefined("form.CtaPres") AND  #form.CtaPres# NEQ -1 AND #form.CtaPres# NEQ "">
  <cfset form.btnFiltrar=1>

<!--- CREACION DE TABLA TEMPORAL --->
  	<cf_dbtemp name="tblNapsXCta" returnvariable="NAPS">
			<cf_dbtempcol name="Linea"  				type="numeric">
			<cf_dbtempcol name="CPcuenta"     			type="numeric">
			<cf_dbtempcol name="Ecodigo"  	    		type="int">
			<cf_dbtempcol name="CPformato"    	    	type="char(100)">
			<cf_dbtempcol name="CPNAPnum"     	    	type="numeric">
			<cf_dbtempcol name="CPNAPDlinea"  	    	type="int">
			<cf_dbtempcol name="CPCano"       	    	type="int">
			<cf_dbtempcol name="CPCmes"       	    	type="int">
			<cf_dbtempcol name="CPNAPmoduloOri"	    	type="char(4)">
			<cf_dbtempcol name="CPNAPdocumentoOri"  	type="varchar(20)">
			<cf_dbtempcol name="CPNAPDtipoMov"      	type="char(2)">
			<cf_dbtempcol name="CPNAPDmontoOri"     	type="money">
			<cf_dbtempcol name="CPNAPDtipoCambio"   	type="float(15)">
			<cf_dbtempcol name="CPNAPDdisponibleAntes"  type="money">
			<cf_dbtempcol name="CPNAPDmonto"         	type="money">
			<cf_dbtempcol name="DisponibleGenerado"    	type="money">
			<cf_dbtempcol name="Original"    	        type="money">
			<cf_dbtempcol name="Modificado"    	        type="money">
			<cf_dbtempcol name="Trasladado"    	        type="money">
			<cf_dbtempcol name="Autorizado"    	        type="money">
			<cf_dbtempcol name="Reservado"    	        type="money">
			<cf_dbtempcol name="Comprometido"    	    type="money">
			<cf_dbtempcol name="Ejecutado"    	        type="money">
			<cf_dbtempcol name="Consumido"    	        type="money">
			<cf_dbtempcol name="Ejercido"    	        type="money">
			<cf_dbtempcol name="Pagado"    	            type="money">
			<cf_dbtempcol name="Disponible"    	        type="money">

			<cf_dbtempkey cols="Linea">
	</cf_dbtemp>

<!--- QUERY PRINCIPAL --->
	<cfquery name="rsListReportNaps" datasource="#Session.DSN#">
	drop table #NAPS#

	select 0 as Linea, c.CPcuenta, c.Ecodigo, c.CPformato, b.CPNAPnum, b.CPNAPDlinea,
	b.CPCano, b.CPCmes, a.CPNAPmoduloOri, a.CPNAPdocumentoOri, b.CPNAPDtipoMov,
	b.CPNAPDmontoOri, b.CPNAPDtipoCambio,
	b.CPNAPDdisponibleAntes, b.CPNAPDmonto, b.CPNAPDdisponibleAntes + (b.CPNAPDmonto * b.CPNAPDsigno) as DisponibleGenerado,
	round(convert(money, case b.CPNAPDtipoMov when 'A' then b.CPNAPDmonto else 0.00 end),2) as Original,
	round(convert(money, case b.CPNAPDtipoMov when 'M' then b.CPNAPDmonto else 0.00 end),2) as Modificado,
	round(convert(money, case b.CPNAPDtipoMov when 'T' then b.CPNAPDmonto when 'TE' then b.CPNAPDmonto else 0.00 end),2) as Trasladado,
	0.00 as Autorizado,
	round(convert(money, case b.CPNAPDtipoMov when 'RC' then b.CPNAPDmonto when 'RP' then b.CPNAPDmonto else 0.00 end),2) as Reservado,
	round(convert(money, case b.CPNAPDtipoMov when 'CC' then b.CPNAPDmonto else 0.00 end),2) as Comprometido,
	round(convert(money, case b.CPNAPDtipoMov when 'E' then b.CPNAPDmonto else 0.00 end),2) as Ejecutado,
	0.00 as Consumido,
	round(convert(money, case b.CPNAPDtipoMov when 'EJ' then b.CPNAPDmonto else 0.00 end),2) as Ejercido,
	round(convert(money, case b.CPNAPDtipoMov when 'P' then b.CPNAPDmonto else 0.00 end),2) as Pagado,
	0.00 as Disponible
	into #NAPS#
	from CPNAP a
	inner join CPNAPdetalle b
		inner join CPresupuesto c
		on b.Ecodigo = c.Ecodigo and b.CPcuenta = c.CPcuenta
		and c.CPformato like '#TRIM(form.CtaPres)#'
	on a.Ecodigo = b.Ecodigo and a.CPNAPnum = b.CPNAPnum
	where a.CPPid = #TRIM(form.CPPid)#
	<cfif isDefined("form.LModulos") AND  #form.LModulos# NEQ "">
		and UPPER(a.CPNAPmoduloOri) like '%#UCase(TRIM(form.LModulos))#%'
	</cfif>
	<cfif isDefined("form.txtDocument") AND  #form.txtDocument# NEQ "">
		and UPPER(a.CPNAPdocumentoOri) like ('%#UCase(TRIM(form.txtDocument))#%')
	</cfif>
	<cfif isDefined("form.txtReferencia") AND  #form.txtReferencia# NEQ "">
		and UPPER(a.CPNAPreferenciaOri) like ('%#UCase(TRIM(form.txtReferencia))#%')
	</cfif>
	<cfif isDefined("form.txtDesdeNap") AND  #form.txtDesdeNap# NEQ "">
	    and a.CPNAPnum >= #form.txtDesdeNap#
	</cfif>
	<cfif isDefined("form.txtHastaNap") AND  #form.txtHastaNap# NEQ "">
	    and a.CPNAPnum <= #form.txtHastaNap#
	</cfif>
	<cfif isDefined("form.FechaNapD") AND  #form.FechaNapD# NEQ "">
	    and a.CPNAPfecha >= '#LSDateFormat(TRIM(form.FechaNapD),'yyyy-mm-dd')#'
	</cfif>
	<cfif isDefined("form.FechaNapH") AND  #form.FechaNapH# NEQ "">
	    and a.CPNAPfecha <= '#LSDateFormat(TRIM(form.FechaNapH),'yyyy-mm-dd')#'
	</cfif>
	<cfif isDefined("form.FechaOriD") AND  #form.FechaOriD# NEQ "">
	    and a.CPNAPfechaOri >= '#LSDateFormat(TRIM(form.FechaOriD),'yyyy-mm-dd')#'
	</cfif>
	<cfif isDefined("form.FechaOriH") AND  #form.FechaOriH# NEQ "">
	    and a.CPNAPfechaOri <= '#LSDateFormat(TRIM(form.FechaOriH),'yyyy-mm-dd')#'
	</cfif>
	order by b.CPCano, b.CPCmes, b.CPNAPnum, b.CPNAPnumRef desc, b.CPNAPDsigno*b.CPNAPDmonto desc, b.CPNAPDlinea

	alter table #NAPS# alter column Autorizado money null
	alter table #NAPS# alter column Consumido money null
	alter table #NAPS# alter column Disponible money null

	Declare @Cont as Integer
	select @Cont = 0
	update #NAPS# set Linea = @Cont, @Cont = @Cont+1

	update #NAPS# SET
	Autorizado = Original + Modificado + Trasladado,
	Consumido = Reservado + Comprometido + Ejecutado,
	Disponible = (Original +  Modificado + Trasladado) -
				(Reservado + Comprometido + Ejecutado)
	where Linea = 1

	update #NAPS# SET
	Original = Original +
	(select sum(b.Original) from #NAPS#  b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Modificado = Modificado +
	(select sum(b.Modificado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Trasladado = Trasladado +
	(select sum(b.Trasladado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Autorizado = Original + Modificado + Trasladado +
	(select sum(b.Original + b.Modificado + b.Trasladado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Reservado = Reservado +
	(select sum(b.Reservado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Comprometido = Comprometido +
	(select sum(b.Comprometido) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Ejecutado = Ejecutado +
	(select sum(b.Ejecutado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Consumido = Reservado + Comprometido + Ejecutado +
	(select sum(b.Reservado + b.Comprometido + b.Ejecutado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Ejercido = Ejercido +
	(select sum(b.Ejercido) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Pagado = Pagado +
	(select sum(b.Pagado) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea),
	Disponible = (Original +  Modificado + Trasladado) -
				(Reservado + Comprometido + Ejecutado) +
	(select sum((b.Original +  b.Modificado + b.Trasladado) -
				(b.Reservado + b.Comprometido + b.Ejecutado)) from #NAPS# b where b.CPformato = #NAPS#.CPformato and b.Linea < #NAPS#.Linea)
	where Linea > 1

	</cfquery>

	<cfquery name="rsListReportNaps" datasource="#Session.DSN#">
	select top 500 * from #NAPS#
	</cfquery>

	<!---<cfdump var="#rsListReportNaps#">--->
<!---      ************     QUERY PERIODOS    ************* --->
<cfquery name="rsPeriodo" datasource="#Session.DSN#">
			select CPPid,
				   CPPtipoPeriodo,
				   CPPfechaDesde,
				   CPPfechaHasta,
				   CPPfechaUltmodif,
				   CPPestado,
				   'Presupuesto ' #_Cat#
						case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat#
							case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
							#_Cat# ' a ' #_Cat#
							case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
					as CPPdescripcion
			from CPresupuestoPeriodo p
			where p.Ecodigo = #Session.Ecodigo#
			  and p.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
	</cfquery>
<!---      ************     ENCABEZADOS    ************* --->
	<cfset form.Ecodigo=rsListReportNaps.Ecodigo>
	<cfif #rsListReportNaps.recordcount# GT 0>
		<cfinvoke
	 component="sif.Componentes.pListas"
	 method="pListaQuery"
	 returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsListReportNaps#"/>
		<cfinvokeargument name="desplegar" value="CPformato,CPNAPnum,CPNAPDlinea,CPCano,CPCmes,
		                                          CPNAPmoduloOri,CPNAPdocumentoOri,CPNAPDtipoMov,
		                                          CPNAPDmontoOri,CPNAPDtipoCambio,CPNAPDdisponibleAntes,
		                                          CPNAPDmonto,DisponibleGenerado,Original,Modificado,
		                                          Trasladado,Autorizado,Reservado,Comprometido,
		                                          Ejecutado,Consumido,Ejercido,Pagado,Disponible"/>
		<cfinvokeargument name="etiquetas" value="Cuenta,NAP,NAP-Linea,Periodo,Mes,Origen,Documento,
		                                          Tipo<br>Movimiento,Monto<br>Origen,Tipo<br>Cambio,
		                                          Disponible<br>Antes,Movimiento<br>Autorizado,
		                                          Disponible<br>Generado,Autorizado,Ordinario,
		                                          Trasladado,Autorizado,Reservado,Comprometido,
		                                          Devengado,Consumido<br>Total,Ejercido,Pagado,Disponible"/>
		<cfinvokeargument name="formatos" value="V,V,V,V,V,V,V,V,M,V,M,M,
		                                         M,M,M,M,M,M,M,M,M,M,M,M"/>
		<cfinvokeargument name="align" value="left,center,center,center,center,center,center,
		                                      center,right,center,right,right,right,right,
		                                      right,right,right,right,right,right,right,
		                                      right,right,right"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="irA" value="../../consultas/ConsNAP.cfm"/>
		<cfinvokeargument name="keys" value="CPNAPnum, CPcuenta, Ecodigo"/>
		<cfinvokeargument name="formName" value="listNAPsCta"/>
		<cfinvokeargument name="PageIndex" value="3"/>
		<cfinvokeargument name="MaxRows" value="0"/>
		<cfinvokeargument name="incluyeForm" value="true"/>
		<cfinvokeargument name="navegacion" value="&CtaPres=#form.CtaPres#&Ecodigo=#form.Ecodigo#&CPPid=#form.CPPid#"/>
		<cfinvokeargument name="debug" value="N"/>
	</cfinvoke>
	</cfif>
	<cfif #rsListReportNaps.recordcount# EQ 0>
		<br><br>
		<div align="center">-- No existe informaci&oacute;n que coincida con los filtros proporcionados --</div>
		<br>
	</cfif>
<br>
	<cfif #rsListReportNaps.recordcount# EQ 500>
		<br>
		<div>* Reporte limitado a 500 registros, cambie los filtros u oprima <strong>Imprimir</strong> para ver el reporte completo.</div>
		<br>
	</cfif>
</cfif>
</cfoutput>
<!--- FUNCIONES JAVASCRIPT --->
<script>
	var GvarSubmit = false;
	function sbSubmit()
	{
		GvarSubmit = true;
		return true;
	}

	function validateData()
	{
		var numCuenta = document.form1.CtaPres;
		var periodo = document.getElementById("CPPid")
		if(numCuenta.value == ""){
			alert('Favor de ingresar una cuenta')
			numCuenta.focus()
		}else if(periodo.value == '-1'){
			alert('Favor de seleccionar un periodo')
			periodo.focus()
		}else{
			document.form1.submit();
		}
	}

	function printReport()
	{
		var numCuenta = document.form1.CtaPres;
		var periodo = document.getElementById("CPPid")
		if(numCuenta.value == ""){
			alert('Favor de ingresar una cuenta')
			numCuenta.focus()
		}else if(periodo.value == '-1'){
			alert('Favor de seleccionar un periodo')
			periodo.focus()
		}else{
			document.form1.action = "NapsXCta-imprimir.cfm";
			document.form1.submit();
		}
	}
</script>

<cf_web_portlet_end>