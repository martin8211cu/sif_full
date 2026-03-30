<!---  
	Se modifica en lo siguiente:
		a.	Se elimina el <cfoutput> </cfoutput> de todo el form para hacerlo por secciones.  
			Así no se almacena todo el resultado en memoria al estar dentro de tag de inicio y fin
		b.	Se modifica el esquema de concatenación para que sea compatible con Sybase, Oracle y MS SqlServer
		c.	Cambio a SQL ANSII en las sentencias Select 
--->
<cfset LvarCPformTipo = session.CPformTipo>
<cfif LvarCPformTipo EQ "registro" and isdefined("form.chkCancelados")>
	<cfset LvarCPformTipo = "cancelados">
</cfif>
<cfparam name="LvarTrasladoExterno" default="false">
<cfif LvarCPformTipo EQ "aprobacion">
	<cfset LvarTrasladoForm = ''>
	<cfset LvarWhereCPDEtipos = " in ('E','T')">
<cfelseif LvarTrasladoExterno>
	<cfset LvarTrasladoForm = 'E'>
	<cfset LvarWhereCPDEtipos = " = 'E'">
	<cfset LvarCPDEtipoDocumento = "E">
<cfelse>
	<cfset LvarTrasladoForm = ''>
	<cfset LvarWhereCPDEtipos = " = 'T'">
	<cfset LvarCPDEtipoDocumento = "T">
</cfif>

<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
<cfset MaxElements = 10>

<cfif isdefined("Form.CPDEid") and Len(Trim(Form.CPDEid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfquery name="rsPeriodos" datasource="#Session.DSN#">
	select CPPid, 
			CPPtipoPeriodo, 
			CPPfechaDesde, 
			CPPfechaHasta, 
			CPPfechaUltmodif, 
			CPPestado
	from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
	and CPPestado = 1
	order by CPPfechaHasta desc, CPPfechaDesde desc
</cfquery>

<cfset LvarDeCtaEnCta = false>
<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsTraslado" datasource="#Session.DSN#">
		select 
             a.CPPid
            ,a.CPDEfecha 
            ,a.CPDEfechaDocumento 
            ,rtrim(a.CPDEnumeroDocumento) as CPDEnumeroDocumento
			,a.CPDEtipoDocumento 
            ,a.CPDEdescripcion
            ,a.CPDEmsgRechazo 
            ,a.Usucodigo
            ,a.CPCano
            ,a.CPCmes 
            ,a.CPDEtipoAsignacion
            ,a.CPTTid, a.CPDAEid, a.CPDEjustificacion
			,tt.CPTTtipoCta
            ,CPPtipoPeriodo
            ,CPPfechaDesde
            ,CPPfechaHasta
            ,a.ts_rversion
            ,c.CFid as CFidOrigen
            ,c.CFcodigo as CFcodigoOrigen
            ,c.CFdescripcion as CFdescripcionOrigen
            ,d.Ocodigo as OcodigoOrigen
            ,d.Odescripcion as Oficina1
            ,e.CFid as CFidDestino
            ,e.CFcodigo as CFcodigoDestino
            ,e.CFdescripcion as CFdescripcionDestino
            ,f.Ocodigo as OcodigoDestino
            ,f.Odescripcion as Oficina2
		from CPDocumentoE a
            inner join CPresupuestoPeriodo b
            on b.CPPid = a.CPPid
            
            inner join CFuncional c
            on c.CFid = a.CFidOrigen
            
            inner join Oficinas d
			on  d.Ecodigo = c.Ecodigo
			and d.Ocodigo = c.Ocodigo

            inner join CFuncional e
			on e.CFid = a.CFidDestino 

            inner join Oficinas f
			on  f.Ecodigo = e.Ecodigo
			and f.Ocodigo = e.Ocodigo

			left join CPtipoTraslado tt
			on a.CPTTid = tt.CPTTid
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPDEid = #Form.CPDEid#
		and a.CPDEtipoDocumento #preserveSingleQuotes(LvarWhereCPDEtipos)#

		and b.Ecodigo = a.Ecodigo
		and c.Ecodigo = a.Ecodigo
		and e.Ecodigo = a.Ecodigo
	</cfquery>
    
	<cfset LvarDeCtaEnCta = rsTraslado.CPTTtipoCta EQ 1>

	<cf_dbfunction name="OP_concat" returnvariable="_CAT">
	<cf_dbfunction name="to_char" args="CPDDid" isnumber="no" returnvariable="LvarCPDDid">
	<cfquery name="rsDocs" datasource="#Session.DSN#">
		select 
				'<img src="/cfmx/sif/imagenes/OP/page-cancel.gif" 	alt="Eliminar Documento"	style="cursor:pointer"	onclick="sbOP(1,'	#_CAT# #preserveSingleQuotes(LvarCPDDid)# #_CAT# ')">' 
				#_CAT#
				'<img src="/cfmx/sif/imagenes/OP/page-down.gif" 	alt="Download"				style="cursor:pointer"	onclick="sbOP(2,'	#_CAT# #preserveSingleQuotes(LvarCPDDid)# #_CAT# ')">' 
				as OP,
				CPDDid, CPDDdescripcion, CPDDarchivo
		  from CPDocumentoEDocs
		 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPDEid#">
	</cfquery>

	<cfset DescripcionPeriodo = 'Presupuesto '>
     
    <cfswitch expression="#rsTraslado.CPPtipoPeriodo#">
        <cfcase value="1"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Mensual'></cfcase>
        <cfcase value="2"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Bimestral'></cfcase>
        <cfcase value="3"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Trimestral'></cfcase>
        <cfcase value="4"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Cuatrimestral'></cfcase>
        <cfcase value="6"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Semestral'></cfcase>
        <cfcase value="12"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Anual'></cfcase>
        <cfdefaultcase><cfset DescripcionPeriodo = DescripcionPeriodo & ''></cfdefaultcase>
    </cfswitch>
    
    <cfset DescripcionPeriodo = DescripcionPeriodo & ' de '>
     
    <cfswitch expression="#Month(rsTraslado.CPPfechaDesde)#">
        <cfcase value="1"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Enero'></cfcase>
        <cfcase value="2"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Febrero'></cfcase>
        <cfcase value="3"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Marzo'></cfcase>
        <cfcase value="4"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Abril'></cfcase>
        <cfcase value="5"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Mayo'></cfcase>
        <cfcase value="6"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Junio'></cfcase>
        <cfcase value="7"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Julio'></cfcase>
        <cfcase value="8"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Agosto'></cfcase>
        <cfcase value="9"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Setiembre'></cfcase>
        <cfcase value="10"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Octubre'></cfcase>
        <cfcase value="11"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Noviembre'></cfcase>
        <cfcase value="12"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Diciembre'></cfcase>
        <cfdefaultcase><cfset DescripcionPeriodo = DescripcionPeriodo & ''></cfdefaultcase>
    </cfswitch>
    <cfset DescripcionPeriodo = DescripcionPeriodo & ' #Year(rsTraslado.CPPfechaDesde)# a '>
    
    <cfswitch expression="#Month(rsTraslado.CPPfechaHasta)#">
        <cfcase value="1"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Enero'></cfcase>
        <cfcase value="2"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Febrero'></cfcase>
        <cfcase value="3"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Marzo'></cfcase>
        <cfcase value="4"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Abril'></cfcase>
        <cfcase value="5"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Mayo'></cfcase>
        <cfcase value="6"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Junio'></cfcase>
        <cfcase value="7"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Julio'></cfcase>
        <cfcase value="8"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Agosto'></cfcase>
        <cfcase value="9"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Setiembre'></cfcase>
        <cfcase value="10"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Octubre'></cfcase>
        <cfcase value="11"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Noviembre'></cfcase>
        <cfcase value="12"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Diciembre'></cfcase>
        <cfdefaultcase><cfset DescripcionPeriodo = DescripcionPeriodo & ''></cfdefaultcase>
    </cfswitch>    
    <cfset DescripcionPeriodo = DescripcionPeriodo & ' #Year(rsTraslado.CPPfechaHasta)#'>

	<cfquery name="rsPartidasOrigen" datasource="#Session.DSN#">
		select a.CPDEid, 
			   a.CPDDlinea, 
			   a.CPDDtipo, 
			   a.CPCano, 
			   a.CPCmes, 
			   a.CPcuenta, 
			   a.CPDDmonto, 
			   coalesce(a.CPDDpeso, 0) as CPDDpeso,
			   b.CPformato,
			   coalesce(b.CPdescripcionF,b.CPdescripcion) as CPdescripcion,
			   a.CPPid, 
			   a.ts_rversion
		from CPDocumentoD a
        	inner join CPresupuesto b
            on b.CPcuenta = a.CPcuenta
		where a.CPDEid = #Form.CPDEid#
		  and a.CPDDtipo = -1
		  and b.Ecodigo = #Session.Ecodigo#
		order by a.CPDDlinea desc
	</cfquery>
	<cfset MaxOrigen = rsPartidasOrigen.recordCount>
	<cfset MaxElements = Max((MaxOrigen+5), MaxElements)>

	<cfquery name="rsPartidasDestino" datasource="#Session.DSN#">
		select a.CPDEid, 
			   a.CPDDlinea, 
			   a.CPDDtipo, 
			   a.CPCano, 
			   a.CPCmes, 
			   a.CPcuenta, 
			   a.CPDDmonto, 
			   coalesce(a.CPDDpeso, 0) as CPDDpeso,
			   b.CPformato,
			   coalesce(b.CPdescripcionF,b.CPdescripcion) as CPdescripcion,
			   a.ts_rversion
		from CPDocumentoD a
        	inner join CPresupuesto b
            on b.CPcuenta = a.CPcuenta
		where a.CPDEid = #Form.CPDEid#
		  and a.CPDDtipo = 1
		  and b.Ecodigo = #Session.Ecodigo#
		order by a.CPDDlinea asc
	</cfquery>
	<cfset MaxDestino = rsPartidasDestino.recordCount>
	<cfset MaxElements = Max((MaxDestino+5), MaxElements)>
	
	<cfquery name="rsCountDetalle" datasource="#Session.DSN#">
		select count(1) as cant
		from CPDocumentoD
		where CPDEid = #Form.CPDEid#
	</cfquery>
</cfif>

<cfquery name="rsCPTT" datasource="#Session.DSN#">
	select  CPTTtipo,
			CPTTid, CPTTcodigo, 
			<cf_dbfunction name="concat" args="' ',case CPTTtipo when 'I' then ' (Interno)' when 'E' then ' (Externa)' end"> as CPTTdescripcion
	from CPtipoTraslado
	where Ecodigo = #Session.Ecodigo#
	<cfif LvarCPformTipo NEQ "registro" and rsTraslado.CPTTid NEQ "">
		and CPTTid = #rsTraslado.CPTTid#
	<cfelseif LvarTrasladoExterno>
		and CPTTtipo = 'E'
	<cfelse>
		and CPTTtipo = 'I'
	</cfif>
	order by CPTTtipo desc
</cfquery>

<cfset LvarTieneDAE = false>
<cfif LvarTrasladoExterno>
	<cfset LvarTieneDAE = true>
	<cfquery name="rsCPDAE" datasource="#Session.DSN#">
		select CPDAEid, 
				CPDAEcodigo,
				CPDAEdescripcion
		from CPDocumentoAE
		where Ecodigo = #Session.Ecodigo#
		  and CPPid in (#valueList(rsPeriodos.CPPid)#)
		  and CPDAEestado = 1
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	var popUpWin=0; 
	var maxElements = <cfoutput>#MaxElements#</cfoutput>;
	var mensajeAlert = true;
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	<cfif modo EQ "CAMBIO">
	function doConlisCuentasOrigen(index) {
		document.form1.CFidTipo.value = "O";
		if (document.form1.CPCano.value != '') {
			var w = 600;
			var h = 300;
			var l = (screen.width-w)/2;
			var t = (screen.height-h)/2;
			popUpWindow("/cfmx/sif/Utiles/ConlisPresupuestoControlCtas.cfm?CPPid="+document.form1.CPPid.value+"&CPCano="+document.form1.CPCano.value+"&CPCmes="+document.form1.CPCmes.value+"&CFidTipo=O&CFid="+document.form1.CFidOrigen.value+"&p1=form1&p2=O_CPcuenta&p3=O_CPformato&p4=O_CPdescripcion&p6="+index,l,t,w,h);
		} else {
			alert('No hay Cuentas de Presupuesto disponibles para el periodo presupuestario seleccionado');
		}
	}
	function doConlisCuentasDestino(index) {
		document.form1.CFidTipo.value = "D";
		if (document.form1.CPCano.value != '') {
			var w = 600;
			var h = 300;
			var l = (screen.width-w)/2;
			var t = (screen.height-h)/2;
			popUpWindow("/cfmx/sif/Utiles/ConlisPresupuestoControlCtas.cfm?CPPid="+document.form1.CPPid.value+"&CPCano="+document.form1.CPCano.value+"&CPCmes="+document.form1.CPCmes.value+"&CFidTipo=D&CFid="+document.form1.CFidDestino.value+"&p1=form1&p2=D_CPcuenta&p3=D_CPformato&p4=D_CPdescripcion&p6="+index,l,t,w,h);
		} else {
			alert('No hay Cuentas de Presupuesto disponibles para el periodo presupuestario seleccionado');
		}
	}
	
	function LimpiarCuenta(idx, pref) {
		if (!idx) {
			for (var k = 1; k <= maxElements; k++) {
				document.form1["O_CPcuenta"+k].value = "";
				document.form1["O_CPformato"+k].value = "";
				document.form1["O_CPdescripcion"+k].value = "";
				document.form1["O_CPDDmonto"+k].value = "0.00";
			}
			for (var k = 1; k <= maxElements; k++) {
				document.form1["D_CPcuenta"+k].value = "";
				document.form1["D_CPformato"+k].value = "";
				document.form1["D_CPdescripcion"+k].value = "";
				document.form1["D_CPDDmonto"+k].value = "0.00";
				document.form1["D_CPDDpeso"+k].value = "0.00";
			}
		} else {
			document.form1[pref+"CPcuenta"+idx].value = "";
			document.form1[pref+"CPformato"+idx].value = "";
			document.form1[pref+"CPdescripcion"+idx].value = "";
			document.form1[pref+"CPDDmonto"+idx].value = "0.00";
			if (pref == 'D_') {
				document.form1["D_CPDDpeso"+idx].value = "0.00";
			}
		}
	}
	
	function Recalcular() {
		return true;
	}
	
	function changeTipo(tipo) {
		switch (tipo) {
			case '0': 
				var tdDestEt = document.getElementById("tdDestEt");
				tdDestEt.style.display = "none";
				var tdDest;
				for (var k = 1; k <= maxElements; k++) {
					tdDest = document.getElementById("tdDest"+k);
					tdDest.style.display = "none";
					document.form1["D_CPDDmonto"+k].readOnly = true;
					document.form1["D_CPDDmonto"+k].style.border = "solid 1px #AAAAAA";
					document.form1["D_CPDDmonto"+k].value = document.form1["O_CPDDmonto"+k].value;
				}
				break;
			
			case '1': 
				var tdDestEt = document.getElementById("tdDestEt");
				tdDestEt.style.display = "none";
				var tdDest;
				for (var k = 1; k <= maxElements; k++) {
					tdDest = document.getElementById("tdDest"+k);
					tdDest.style.display = "none";
					document.form1["D_CPDDmonto"+k].readOnly = true;
					document.form1["D_CPDDmonto"+k].style.border = "solid 1px #AAAAAA";
				}
				break;
			
			case '2':
				var tdDestEt = document.getElementById("tdDestEt");
				tdDestEt.style.display = "none";
				var tdDest;
				for (var k = 1; k <= maxElements; k++) {
					tdDest = document.getElementById("tdDest"+k);
					tdDest.style.display = "none";
					document.form1["D_CPDDmonto"+k].readOnly = false;
					document.form1["D_CPDDmonto"+k].style.border = "inset 2px #CCCCCC";
					document.form1["D_CPDDmonto"+k].style.borderBottom = "solid 1px #CCCCCC";
					document.form1["D_CPDDmonto"+k].style.borderRight = "solid 1px #CCCCCC";
				}
				break;
			
			case '3':
				/*
				var tdet = document.getElementById("etiquetaMonto");
				var tmp1 = tdet.firstChild;
				var t = document.createTextNode("Porcentaje");
				tmp1.replaceChild(t,tmp1.firstChild);
				*/
				var tdDestEt = document.getElementById("tdDestEt");
				tdDestEt.style.display = "";
				var tdDest;
				for (var k = 1; k <= maxElements; k++) {
					tdDest = document.getElementById("tdDest"+k);
					tdDest.style.display = "";
					document.form1["D_CPDDmonto"+k].readOnly = true;
					document.form1["D_CPDDmonto"+k].style.border = "solid 1px #AAAAAA";
				}
				break;
		}
	}
	</cfif>
</script>

<form 	method="post" name="form1" 
		action="traslado-sql.cfm" onSubmit="javascript: return validar(this);"
		enctype="multipart/form-data"
>
<cfoutput>
<cfif modo EQ "CAMBIO">
	<input type="hidden" name="CPDEid" value="#Form.CPDEid#">
	<input type="hidden" name="CPDEmsgrechazo">
	<input type="hidden" name="CPDEtipoDocumento" value="#rsTraslado.CPDEtipoDocumento#">
<cfelse>
	<input type="hidden" name="CPDEtipoDocumento" value="#LvarCPDEtipoDocumento#">
</cfif>
</cfoutput>
  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
	<tr>
	  <td colspan="10" align="center" nowrap class="tituloAlterno">Encabezado de Documento de Traslado de Presupuesto </td>
	  </tr>
	<tr>
	  <td align="right" class="fileLabel" nowrap>Per&iacute;odo:</td>
	  <td nowrap>
	  	<cfif modo EQ 'CAMBIO' and rsCountDetalle.cant NEQ 0>
        	<cfoutput>
			<input type="hidden" name="CPPid" value="#rsTraslado.CPPid#">
			#DescripcionPeriodo#
            </cfoutput>
		<cfelse>
			<cfif modo EQ 'CAMBIO'>
            	<cfoutput><cf_cboCPPid value="#rsTraslado.CPPid#" CPPestado="1" onChange="javascript: alert('Por favor haga click en el botón de Guardar para ver año y mes correctos'); LimpiarCuenta();"></cfoutput>
			<cfelse>
				<cf_cboCPPid CPPestado="1">
			</cfif>
		</cfif>
	  </td>
	  <td align="right" nowrap class="fileLabel">No. Documento:</td>
	  <td nowrap>
	  	<cfif modo EQ 'CAMBIO'>
			<cfoutput>#rsTraslado.CPDEnumeroDocumento#</cfoutput>
		</cfif>
	  </td>
	  <td align="right" nowrap class="fileLabel">Fecha Doc:</td>
	  <td nowrap>
		<cfif modo EQ "CAMBIO">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 30
			</cfquery>
			<cfset LvarAuxAno = rsSQL.Pvalor>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 40
			</cfquery>
			<cfset LvarAuxMes = rsSQL.Pvalor>
			<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
			<cfset LvarDocAnoMes = rsTraslado.CPCano*100+rsTraslado.CPCmes>

			<cfset fecha = DateFormat(rsTraslado.CPDEfechaDocumento, 'dd/mm/yyyy')>
			<cfif LvarCPformTipo NEQ "cancelados" AND LvarDocAnoMes LT LvarAuxAnoMes>
				<cfif LvarCPformTipo EQ "aprobacion">
					<script language="javascript">
						alert ("La fecha del documento no puede ser menor al Mes de Contabilidad");
						<cfset LvarNOTaprobar = true>
					</script>
				<cfelse>
					<font color="#FF0000"><strong>Anterior: <cfoutput>#DateFormat(rsTraslado.CPDEfechaDocumento, 'dd/mm/yyyy')#</cfoutput></strong></font>
					<cfif DateFormat(Now(), 'yyyymm') EQ LvarAuxAnoMes>
						<cfset fecha = DateFormat(Now(), 'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha = DateFormat(CreateDate(dateFormat(Now(), 'yyyy'),dateFormat(Now(), 'mm'),1),'dd/mm/yyyy')>
					</cfif>
					<cfset rsTraslado.CPCano = LvarAuxAno>
					<cfset rsTraslado.CPCmes = LvarAuxMes>
					<script language="javascript">
						alert ("La fecha del documento no puede ser menor al Mes de Contabilidad");
						<cfset LvarNOTsolicitar = true>
					</script>
				</cfif>
			</cfif>
		<cfelse>
			<cfset fecha = DateFormat(Now(), 'dd/mm/yyyy')>
		</cfif>
		<cf_sifcalendario name="CPDEfechaDocumento" form="form1" value="#fecha#">
        </td>
	  <td align="right" class="fileLabel" nowrap>
	  	<cfif modo EQ "CAMBIO">A&ntilde;o:<cfelse>&nbsp;</cfif>
	  </td>
	  <td nowrap>
	  	<cfif modo EQ "CAMBIO">
        	<cfoutput>
			<input type="hidden" name="CPCano" value="#rsTraslado.CPCano#">
			#rsTraslado.CPCano#
            </cfoutput>
		<cfelse>
			&nbsp;
		</cfif>
	   </td>
	  <td align="right" nowrap class="fileLabel">
	  	<cfif modo EQ "CAMBIO">Mes:<cfelse>&nbsp;</cfif>
	  </td>
	  <td nowrap>
	  	<cfif modo EQ "CAMBIO">
			<input type="hidden" name="CPCmes" value="<cfoutput>#rsTraslado.CPCmes#</cfoutput>">
			<cfif isdefined('rsTraslado') and rsTraslado.recordCount GT 0>
				<cfoutput>#ListGetAt(meses, rsTraslado.CPCmes, ',')#</cfoutput>
			</cfif>
		<cfelse>
			&nbsp;
		</cfif>
	  </td>
	  </tr>
	<tr>
		<td class="fileLabel" align="right" nowrap>Descripci&oacute;n: </td>
		<td nowrap>
			<cfoutput><input type="text" name="CPDEdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsTraslado.CPDEdescripcion#</cfif>"></cfoutput>
		</td>
		<td align="right" nowrap class="fileLabel">Centro Funcional:</td>
		<td colspan="4" nowrap>
			<input type="hidden" id="CFidTipo" name="CFidTipo" value="">
			<cfif modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0>
            	<cfoutput>#rsTraslado.CFcodigoOrigen# - #rsTraslado.CFdescripcionOrigen#</cfoutput>
				<input type="hidden" id="CFidOrigen" name="CFidOrigen" value="<cfoutput>#rsTraslado.CFidOrigen#</cfoutput>">
			<cfelseif modo EQ "CAMBIO">
				<cfoutput><cf_CPSegUsu_cboCFid name="CFidOrigen" value="#rsTraslado.CFidOrigen#"></cfoutput>
			<cfelse>
				<cf_CPSegUsu_cboCFid name="CFidOrigen">
			</cfif>	  
		</td>
		<td colspan="2" align="right" nowrap class="fileLabel">&nbsp;
		</td>
	</tr>
	<tr>
	  <td align="right" class="fileLabel" nowrap>Base Traslado:</td>
	  <td nowrap>
      	<select name="CPDEtipoAsignacion"<cfif MODO EQ "CAMBIO"> onChange="javascript: changeTipo(this.value);"</cfif>>
			<cfif LvarDeCtaEnCta>
	            <option value="0" selected>Asignaci&oacute;n de Cuenta a Cuenta</option>
			<cfelse>
				<option value="2"<cfif modo EQ 'CAMBIO' and rsTraslado.CPDEtipoAsignacion EQ 2> selected</cfif>>Asignaci&oacute;n manual de montos</option>
				<option value="0"<cfif modo EQ 'CAMBIO' and rsTraslado.CPDEtipoAsignacion EQ 0> selected</cfif>>Asignaci&oacute;n de Cuenta a Cuenta</option>
				<option value="1"<cfif modo EQ 'CAMBIO' and rsTraslado.CPDEtipoAsignacion EQ 1> selected</cfif>>Distribuci&oacute;n equitativa</option>
				<option value="3"<cfif modo EQ 'CAMBIO' and rsTraslado.CPDEtipoAsignacion EQ 3> selected</cfif>>Distribuci&oacute;n por pesos</option>
			</cfif>
      	</select>	  
	  </td>
	  <td align="right" nowrap class="fileLabel">C. F. Destino:</td>
	  <td colspan="4" nowrap>
	  	<cfif modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0>
			<cfoutput>#rsTraslado.CFcodigoDestino# - #rsTraslado.CFdescripcionDestino#</cfoutput>
			<input type="hidden" id="CFidDestino" name="CFidDestino" value="<cfoutput>#rsTraslado.CFidDestino#</cfoutput>">
		<cfelseif modo EQ "CAMBIO">
			<cfoutput><cf_rhcfuncional form="form1" size="40" query="#rsTraslado#" index="Destino"></cfoutput>
		<cfelse>
			<cf_rhcfuncional form="form1" size="40" index="Destino">
		</cfif>	 
	  </td>
	  <td colspan="2" align="right" nowrap class="fileLabel">&nbsp;
			
	  </td>
	  </tr>
	<cfset LvarCPTT_PtoExt = -1>			
	<cfset LvarCPTT_Ext = false>			
	<cfif rsCPTT.recordCount NEQ 0>
	<tr>
	  <td align="right" class="fileLabel" nowrap>Tipo de Traslado:</td>
	  <td nowrap>
	  	<select name="CPTTid" id="CPTTid">
		<cfif rsCPTT.recordCount GT 1 OR MODO EQ "CAMBIO">
		<option>(Escoja el Tipo de Traslado)</option>
		<cfset LvarCPTT_PtoExt = 0>
		</cfif>
		<cfoutput query="rsCPTT" group="CPTTtipo">
			<cfif CPTTtipo EQ "I">
				<optgroup label="Traslados Autorización Interna:">
			<cfelse>
				<cfset LvarCPTT_Ext = true>
				<cfif NOT LvarCPTT_Ext>
					<cfset LvarCPTT_PtoExt += rsCPTT.currentRow>
				</cfif>
				<optgroup label="Traslados Autorización Externa:">
			</cfif>
			<cfoutput>
					<option value="#rsCPTT.CPTTid#" <cfif MODO EQ "CAMBIO" AND rsCPTT.CPTTid EQ rsTraslado.CPTTid>selected</cfif>>#trim(rsCPTT.CPTTcodigo)# - #rsCPTT.CPTTdescripcion#</option>
			</cfoutput>
				</optgroup>
		</cfoutput>
		</select>
	  </td>
	  </cfif>
	  <td align="right" nowrap class="fileLabel">Motivo Rechazo:</td>
	  <td colspan="4" nowrap>
		<cfif modo EQ "CAMBIO"><font color="#FF0000"><cfoutput>#rsTraslado.CPDEmsgRechazo#</cfoutput></font></cfif>
	  </td>
	</tr>
	<cfif LvarTieneDAE>
		<tr id="TRtrasladoE">
		  <td align="right" class="fileLabel" nowrap>Autorización Externa:</td>
			  <td nowrap>
				<select name="CPDAEid" id="CPDAEid">
					<cfif rsCPDAE.recordCount EQ 0>
					<option value="">(No existen Documentos de Autorización Externa)</option>
					<cfelseif rsCPDAE.recordCount GT 1 OR MODO EQ "CAMBIO">
					<option value="">(Escoja un Documento de Autorización Externa)</option>
					</cfif>
					<cfoutput query="rsCPDAE">
						<option value="#CPDAEid#" <cfif MODO EQ "CAMBIO" AND rsCPDAE.CPDAEid EQ rsTraslado.CPDAEid>selected</cfif>>#CPDAEcodigo# - #CPDAEdescripcion#</option>
					</cfoutput>
				</select>
			  </td>
		</tr>

	</cfif>
	<tr>
	  <td colspan="10" align="center" nowrap>
		<cfset ts = "">
		<cfif modo NEQ "ALTA">
		  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsTraslado.ts_rversion#" returnvariable="ts">
		  </cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
		<cfif LvarCPformTipo EQ "aprobacion">
			<input type="submit" name="btnAplicar" value="Aprobar" onclick="javascript: if ( confirm('¿Está seguro(a) de que desea APROBAR este documento de traslado de presupuesto?') ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}" <cfif isdefined("LvarNOTaprobar")>disabled</cfif>>
			<input type="submit" name="btnRechazar" value="Rechazar" onclick="javascript: if ( fnProcessRechazo() ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}">
		<cfelseif LvarCPformTipo EQ "cancelados">
			<input type="submit" name="btnDuplicar" value="Duplicar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
		<cfelseif modo EQ "ALTA">
			<input type="submit" name="btnAgregarE" value="Agregar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
		<cfelse>
			<cfif LvarCPformTipo EQ "registro">
				<input type="submit" name="btnModificarT" value="Modificar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
				<input type="reset" name="btnResetD" value="Reset Detalles">
				&nbsp;&nbsp;
			</cfif>
			<input type="submit" name="btnBajaE" value="Eliminar" onclick="javascript: if ( confirm('¿Está seguro(a) de que desea eliminar el Traslado de Presupuesto?') ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}">
			<input type="submit" name="btnNuevoE" value="Nuevo" onClick="javascript: if (window.inhabilitarValidacion) inhabilitarValidacion(); ">
			<cfif modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0>
				<input type="submit" name="btnVerificar" value="Verificar" onclick="javascript: if (window.habilitarValidacion) habilitarValidacion(); return true;">
				<input type="submit" name="btnAAprobar" value="A Aprobar" onclick="javascript: if ( confirm('¿Está seguro(a) de que desea enviar a aprobar este documento de traslado de presupuesto para el mes ' + document.form1.CPDEfechaDocumento.value.substr(3,7) + '?') ){ if (window.habilitarValidacion) habilitarValidacion(); return true; }else{ return false;}" <cfif isdefined("LvarNOTsolicitar")>disabled</cfif>>				
			</cfif>
		<cfif rsTraslado.CPDEtipoAsignacion EQ 0>
			<!---<cfthrow message="NO SIRVE #rsTraslado.CPDEtipoAsignacion#">--->
			<cfset Session.CPDEid = #form.CPDEid#>
			<input type="submit" name="btnImportar" value="Importar" onclick="javascript:funcImportar();;">
		</cfif>
		</cfif>
		<cfoutput><input type="button" name="btnRegresar" value="Ir a Lista" onClick="javascript: location.href='traslado#LvarTrasladoForm#-#session.CPformTipo#-lista.cfm';"></cfoutput>		
	  </td>
	</tr>
	<tr>
	  <td colspan="10">&nbsp;</td>
	</tr>
</table>
<cfif modo EQ "CAMBIO">
	<cfparam name="form.tab" default="0">
	<input type="hidden" name="tab" id="tab" value="<cfoutput>#form.tab#</cfoutput>">
	<cf_tabs width="99%" onclick="tabChange">
		<cf_tab text="Cuentas" selected="#form.tab EQ 0#" id="0">
			<cfinclude template="traslado-detCtas.cfm">
		</cf_tab>
		<cfif rtrim(rsTraslado.CPDEjustificacion) NEQ "" OR LvarCPformTipo EQ "registro">
			<cf_tab text="Justificación" selected="#form.tab EQ 1#" id="1">
				<cfinclude template="traslado-detJust.cfm">
			</cf_tab>
		</cfif>
		<cfif rsDocs.recordCount GT 0 OR LvarCPformTipo EQ "registro">
			<cf_tab text="Documentación" selected="#form.tab EQ 2#" id="2">
				<cfinclude template="traslado-detDocs.cfm">
			</cf_tab>
		</cfif>
	</cf_tabs>
	<script language="javascript">
		function tabChange(t)
		{
			 document.getElementById("tab").value=t;
			 tab_set_current(t);
		}
	</script>
</cfif>
</form>

<script language="JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	var inicioPeriodo = new Object("");
	var finPeriodo = new Object("");
	<cfoutput>
	<cfloop query="rsPeriodos">
		inicioPeriodo['#rsPeriodos.CPPid#'] = "#DateFormat(CPPfechaDesde, 'dd/mm/yyyy')#";
		finPeriodo['#rsPeriodos.CPPid#'] = "#DateFormat(CPPfechaHasta, 'dd/mm/yyyy')#";
	</cfloop>
	</cfoutput>

	function fnProcessRechazo(){
		var vReason = prompt('¿Está seguro(a) de que desea RECHAZAR este documento de traslado de presupuesto?, Debe digitar una razón de rechazo!','');
		if (vReason && vReason != ''){
			document.form1.CPDEmsgrechazo.value = vReason;
			return true;
		}
		if (vReason=='')
			alert('Debe digitar una razón de rechazo!');
		return false;
	}
	
	function validar(f) {
		var result = true;
		<cfif modo EQ "CAMBIO">
		var msg = "";
		var suma = 0.00;
		<!---
		// Comentado por ahora porque no se sabe si los porcentajes deben sumar 100
		if (document.form1.CPDEtipoAsignacion.value == 3) {
			for (var k = 1; k <= maxElements; k++) {
				suma = suma + parseFloat(qf(document.form1["D_CPDDpeso"+k].value));
				if (parseFloat(qf(document.form1["D_CPDDpeso"+k].value)) > 100) {
					msg = "El porcentaje de asignación para una cuenta destino no puede ser mayor a 100";
					result = false;
				}
			}
		}
		if ((document.form1.CPDEtipoAsignacion.value == 3) && result && (suma > 100)) {
			msg = "La suma de los porcentajes de asignación para las cuentas destino no puede ser mayor a 100";
			result = false;
		}
		<!--- Validación de Cumplimiento de Montos Disponibles --->
		for (var k = 1; k <= maxElements; k++) {
			result = validateDisponible(document.form1["O_CPDDmonto"+k], k);
			if (!result) break;
		}
		--->

		if (document.form1.CPDEtipoAsignacion.value == 0 && objForm.CPPid.required)
		{
			for (var k = 1; k <= maxElements; k++) 
			{
				if ( (document.form1["O_CPcuenta"+k].value != "") && (document.form1["D_CPcuenta"+k].value == ""))
				{
					result = false;
					msg = 'Falta la cuenta en la linea ' + k;
				}
				else if (document.form1["O_CPcuenta"+k].value == "")
				{
					document.form1["D_CPcuenta"+k].value = ""
				}
				else
				{
					document.form1["D_CPDDmonto"+k].value = document.form1["O_CPDDmonto"+k].value;
				}
			}
		}
		if (result) { 
			for (var k = 1; k <= maxElements; k++) {
				document.form1["O_CPDDmonto"+k].value = qf(document.form1["O_CPDDmonto"+k].value);
			}
			if (document.form1.CPDEtipoAsignacion.value == 3) {
				for (var k = 1; k <= maxElements; k++) {
					document.form1["D_CPDDpeso"+k].value = qf(document.form1["D_CPDDpeso"+k].value);
				}
			}
			for (var k = 1; k <= maxElements; k++) {
				document.form1["D_CPDDmonto"+k].value = qf(document.form1["D_CPDDmonto"+k].value);
			}
		} else {
			if (msg != '') alert(msg);
		}
		</cfif>
		return result;
	}

	function habilitarValidacion() {
		objForm.CPPid.required = true;
		objForm.CPDEfechaDocumento.required = true;
		objForm.CPDEdescripcion.required = true;
		<cfif rsCPTT.recordCount NEQ 0>
			objForm.CPTTid.required = true;
		</cfif>
		<cfif LvarTieneDAE>
			objForm.CPDAEid.required = true;
		</cfif>	
	  	<cfif not (modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0)>
			objForm.CFidOrigen.required = true;
			objForm.CFcodigoDestino.required = true;
		</cfif>
		<cfif modo EQ "CAMBIO">
			inhabilitarValidacionD();
		</cfif>
	}
	
	function inhabilitarValidacion() {
		objForm.CPPid.required = false;
		objForm.CPDEfechaDocumento.required = false;
		objForm.CPDEdescripcion.required = false;
		<cfif rsCPTT.recordCount NEQ 0>
			objForm.CPTTid.required = false;
		</cfif>
		<cfif LvarTieneDAE>
			objForm.CPDAEid.required = false;
		</cfif>	
	  	<cfif not (modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0)>
			objForm.CFidOrigen.required = false;
			objForm.CFcodigoDestino.required = false;
		</cfif>
		<cfif modo EQ "CAMBIO">
			inhabilitarValidacionD();
		</cfif>
	}

	<cfif modo EQ "CAMBIO">
	function habilitarValidacionD() {
	}

	function inhabilitarValidacionD() {
	}
	</cfif>

	function __isNotCero() {
		if (this.required && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			this.error = "El campo " + this.description + " no puede ser cero!";
		}
	}

	// Valida que la fecha del documento se encuentra en el rango de un periodo
	function __isFechaDoc() {
		if (this.required) {
			var a = inicioPeriodo[this.obj.form.CPPid.value].split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = finPeriodo[this.obj.form.CPPid.value].split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			var c = this.value.split("/");
			var fechadoc = new Date(parseInt(c[2], 10), parseInt(c[1], 10)-1, parseInt(c[0], 10));
			if (!(fechadoc >= ini && fechadoc <= fin)) {
				this.error = "La Fecha del Documento debe caer dentro del Rango de Fechas del Periodo de Presupuesto seleccionado";
			}
		}
	}

	// Valida que el monto no sobrepase al disponible
	function validateDisponible(ctl, k) {
		var pref = ctl.name.substr(0,2);
		if (ctl.form[pref + 'CPcuenta' + k].value != '' && ctl.form[pref + 'validarDisponible' + k] && ctl.form[pref + 'validarDisponible' + k].value == '1') {
			if (parseFloat(qf(ctl.form[pref + 'disponible' + k].value)) < parseFloat(qf(ctl.value))) {
				alert("El monto para la cuenta " + ctl.form[pref + 'CPdescripcion' + k].value + " sobrepasa el máximo disponible para esa cuenta");
				return false;
			}
		}
		return true;
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isFechaDoc", __isFechaDoc);

	objForm.CPPid.required = true;
	objForm.CPPid.description = "Período para Presupuesto";
	objForm.CPDEfechaDocumento.required = true;
	objForm.CPDEfechaDocumento.description = "Fecha";
	objForm.CPDEfechaDocumento.validateFechaDoc();
	objForm.CPDEdescripcion.required = true;
	objForm.CPDEdescripcion.description = "Descripción";
	<cfif rsCPTT.recordCount NEQ 0>
		objForm.CPTTid.required = true;
		objForm.CPTTid.description = "Tipo de Traslado";
	</cfif>
	<cfif LvarTieneDAE>
		objForm.CPDAEid.required = true;
		objForm.CPDAEid.description = "Documento de Autorización Externa";
	</cfif>	
	<cfif not (modo EQ "CAMBIO" and rsCountDetalle.cant NEQ 0)>
	objForm.CFidOrigen.required = true;
	objForm.CFidOrigen.description = "Centro Funcional Origen";
	objForm.CFcodigoDestino.required = true;
	objForm.CFcodigoDestino.description = "Centro Funcional Destino";
	</cfif>

	<cfif modo EQ "CAMBIO">
		changeTipo(document.form1.CPDEtipoAsignacion.value);
	</cfif>
	
	function funcImportar() {
		document.form1.action = "../importador/ImportadorTrasladoPpto_Form.cfm";
		document.form1.submit();
	}

</script>
