<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se corrige la navegación del form con los tabs para que tengan un orden lógico.
 --->
<cfset BlockCamposInput = "">
<cfif isdefined("Form.IncVal")>
	<cfset BlockCamposInput = "readonly">
</cfif>

<!--- DEFINICION DE PARAMETROS DE PAGINACION Y FILTROS --->
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
	<cfset form.Pagina2 = url.Pagina2>
</cfif>					
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
	<cfset form.Pagina2 = url.PageNum_Lista2>
	<!--- RESETEA LA LLAVE CUANDO NAVEGA --->
	<cfset form.PCDcatid = 0>
</cfif>		

<cfif isdefined("form.BotonSel") and not len(trim(form.BotonSel))>
	<cf_navegacion name="Pagina2" 			default=""  navegacion="">
	<cf_navegacion name="F_PCDvalor" 		default=""  navegacion="">
	<cf_navegacion name="F_PCDdescripcion" 	default=""  navegacion="">
	<cf_navegacion name="cboOficinas" 		default=""  navegacion="">
<cfelse>
	<cf_navegacion name="Pagina2" default=""  session>
	<cf_navegacion name="F_PCDvalor" 		default=""  session>
	<cf_navegacion name="F_PCDdescripcion" 	default=""  session>
	<cf_navegacion name="cboOficinas" 		default=""  session>
</cfif>

<!--- <cfdump var="#session.navegacion#">	 --->
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
	<cfset form.Pagina2 = form.PageNum2>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DEL SQL --->
<cfif isdefined("url.F_PCDvalor") and len(trim(url.F_PCDvalor))>
	<cfset form.F_PCDvalor = url.F_PCDvalor>
</cfif>
<cfif isdefined("url.F_PCDdescripcion") and len(trim(url.F_PCDdescripcion))>
	<cfset form.F_PCDdescripcion = url.F_PCDdescripcion>
</cfif>

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina2" default="1">					
<cfparam name="form.F_PCDvalor" default="">
<cfparam name="form.F_PCDdescripcion" default="">

<!--- DEFINCION DE PARAMETROS ADICIONALES DE LA PANTALLA --->
<cfset DEBUG = false>
<cfset MostrarDetalle=true>

<cfif isdefined("Url.PCEcatid") and not isdefined("Form.PCEcatid")>
	<cfset Form.PCEcatid = Url.PCEcatid>
</cfif>
<cfif isdefined("Url.PCDcatid") and not isdefined("Form.PCDcatid")>
	<cfset Form.PCDcatid = Url.PCDcatid>
</cfif>
<cfif isdefined("form.PCEcatid") and Len(Trim(Form.PCEcatid))>
	<cfset Form.modo = "CAMBIO">
</cfif>

<cfparam name="Url.F_PCDvalor" default="">
<cfparam name="Url.F_PCDdescripcion" default="">
<cfparam name="Url.F_PCEcatidref" default="">


<cfif isdefined("Url.F_PCDvalor") and not isdefined("Form.F_PCDvalor")>
	<cfset Form.F_PCDvalor = Url.F_PCDvalor>
</cfif>
<cfif isdefined("Url.F_PCDdescripcion") and not isdefined("Form.F_PCDdescripcion")>
	<cfset Form.F_PCDdescripcion = Url.F_PCDdescripcion>
</cfif>
<cfif isdefined("Url.F_PCEcatidref") and not isdefined("Form.F_PCEcatidref")>
	<cfset Form.F_PCEcatidref = Url.F_PCEcatidref>
</cfif>

<cfset filtro = "">
<cfset navegacion = "abc=1">
<cfif isdefined("Form.PCEcatid")>
<cfset navegacion = "PCEcatid=" & Form.PCEcatid>
</cfif>
<cfif isdefined('form.F_PCDvalor') and trim(form.F_PCDvalor) NEQ "">
	<cfset filtro = filtro & " and Upper(PCDvalor) like Upper('%#form.F_PCDvalor#%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "F_PCDvalor=" & Form.F_PCDvalor>
</cfif>
<cfif isdefined('form.F_PCDdescripcion') and trim(form.F_PCDdescripcion) NEQ "">
	<cfset filtro = filtro & " and Upper(PCDdescripcion) like Upper('%#form.F_PCDdescripcion#%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "F_PCDdescripcion=" & Form.F_PCDdescripcion>
</cfif>
<cfif isdefined('form.F_PCEcatidref') and trim(form.F_PCEcatidref) NEQ "">
	<cfset filtro = filtro & " and PCEcatidref = #form.F_PCEcatidref#">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"),DE("")) & "F_PCEcatidref=" & Form.F_PCEcatidref>
</cfif>


<!--- DEFINE EL MODO DEL ENCABEZADO --->
<cfif isDefined("Form.btnNuevo")>
	<cfset MODO = "ALTA">
<cfelse>
	<cfif isDefined("Form.MODO") and trim(Form.MODO) eq "CAMBIO" and isDefined("Form.PCEcatid") and len(trim(Form.PCEcatid)) neq 0>
		<cfset MODO = "CAMBIO">
	<cfelse>
		<cfset MODO = "ALTA">
	</cfif>
</cfif>
<cfif isDefined("MostrarDetalle") and MostrarDetalle eq true and MODO eq "CAMBIO">
<!--- DEFINE EL MODO DEL DETALLE --->
	<cfif isDefined("Form.DMODO") and trim(Form.DMODO) eq "CAMBIO" and isDefined("Form.PCDcatid") and len(trim(Form.PCDcatid)) neq 0 and Form.PCDcatid gt 0>
		<cfset DMODO = "CAMBIO">
	<cfelse>
		<cfset DMODO = "ALTA">
	</cfif>
</cfif>

<!--- Consultas del Encabezado --->
<cfif MODO eq "CAMBIO">

	<!--- Consultas que se ejecutan solo en MODO CAMBIO --->
	<cfquery name="rsPCE" datasource="#Session.DSN#">
		select PCEcatid, PCEcodigo, PCEdescripcion, PCElongitud, 
				PCEempresa, PCEoficina, PCEvaloresxmayor,
				PCEref, PCEreferenciar, PCEreferenciarMayor, PCEactivo, Usucodigo, Ulocalizacion, ts_rversion
		from PCECatalogo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
	</cfquery>
	<cfif rsPCE.RecordCount neq 1>
		<cfif rsPCE.RecordCount lt 1>
			<cfset url.errMsg = "La consulta del encabezado del catálogo no produjo ningun resultado.">
		<cfelse>
			<cfset url.errMsg = "La consulta del encabezado del catálogo produjo mas de 1 resultado.">
		</cfif>
		<cflocation url="/sif/errorPages/BDerror.cfm?errMsg=#errMsg#">
	</cfif>
	<cfquery name="rsPCEclas" datasource="#Session.DSN#">
		select cc.PCCEclaid, c.PCCEdescripcion, c.PCCEempresa
		  from PCEClasificacionCatalogo cc
		  	inner join PCClasificacionE c
				on cc.PCCEclaid=c.PCCEclaid
		where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
	</cfquery>
	
	
	<cfif isdefined("rsPCE.PCEempresa") AND rsPCE.PCEempresa eq 1>
		<cfset porEmpresa = "and Ecodigo = #Session.Ecodigo#">
	</cfif>
	
<!---	<cfset porEmpresa = IIf(isDefined("rsPCE.PCEempresa") AND rsPCE.PCEempresa eq 1, DE("and Ecodigo = #Session.Ecodigo#"), DE(""))>
--->	<cfquery name="rsPCEdet" datasource="#Session.DSN#">
		select count(*) as Cantidad
		from PCDCatalogo a
		left outer join PCECatalogo b
		   on a.PCEcatidref = b.PCEcatid
		where a.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
		
	</cfquery>
	
		<!--- Verifica si hay alguna linea de detalle con valores por cuenta mayor --->
	<cfif isdefined("rsPCE.PCEvaloresxmayor") and rsPCE.PCEvaloresxmayor EQ "1">
	
		<!--- Si alguna de las lineas de detalle tiene valores por cuenta mayor asociados --->
		<cfquery datasource="#Session.DSN#" name="rsMayor">
		Select count(1) as total
		from PCECatalogo A, PCDCatalogo B, PCDCatalogoPorMayor C
		where A.PCEcatid = B.PCEcatid 
		  and B.PCEcatid = C.PCEcatid
		  and B.PCDcatid = C.PCDcatid
		  and B.Ecodigo = C.Ecodigo
		  and B.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and A.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
		</cfquery>
						
	</cfif>		
	
		<!--- Verifica si hay alguna linea de detalle con oficinas 
		  en cuyo caso el check no se activa para modificar --->
	<cfif isdefined("rsPCE.PCEoficina") and rsPCE.PCEoficina EQ "1">
				
		<!--- Si alguna de las lineas de detalle tiene oficinas asociadas --->
		<cfquery datasource="#Session.DSN#" name="rsOficinas">
		Select A.Ocodigo, A.Oficodigo, A.Odescripcion
		from Oficinas A, PCDCatalogoValOficina B, PCDCatalogo C, PCECatalogo D
		where A.Ocodigo = B.Ocodigo
		  and A.Ecodigo = B.Ecodigo
		  and B.PCDcatid = C.PCDcatid
		  and C.PCEcatid = D.PCEcatid
		  and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and D.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
		</cfquery>
						
	</cfif>		
	
	<!--- 
		Verifica las lineas de detalle
		--Si no hay lineas de detalle (Puedo modificarlo)
		--Si ya hay lineas de detalle no lo puedo tocar y debe mantener el estado en que está
	 --->
	 <cfquery datasource="#Session.DSN#" name="rsExtDetalle">
		 Select count(1) as cantidad_lineas
		 from PCECatalogo A, PCDCatalogo B
		 where A.PCEcatid = B.PCEcatid
		   and A.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
	 </cfquery>
	
	 <!--- Si no hay lineas de detalle este check es modificable --->
	 <!--- de otra forma no se podrá tocar y mantiene su estado actual --->
	 <cfif rsExtDetalle.cantidad_lineas eq 0>
	 	<cfset modificable = "">
	 <cfelse>
		 <cfset modificable = "disabled">
	 </cfif>
		
	<!--- Verifica si hay alguna linea de detalle con referencias por cuenta de mayor --->	
	<cfif isdefined("rsPCE.PCEreferenciarMayor") and rsPCE.PCEreferenciarMayor EQ "1">
	
		<cfquery datasource="#Session.DSN#" name="rsMayorRef">
		Select C.Cmayor
		from PCECatalogo A, PCDCatalogo B, PCDCatalogoRefMayor C
		where A.PCEcatid = B.PCEcatid		  
		  and B.PCDcatid = C.PCDcatid
		  and B.Ecodigo  = C.Ecodigo		  
		  and B.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and A.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
		</cfquery>	
		
		<cfif rsMayorRef.recordcount gt 0>
			<cfset modificableMayor = "disabled">
		<cfelse>
			<cfset modificableMayor = "">
		</cfif>
	</cfif>
	
<cfelse>
	<!--- Consultas que se ejecutan solo en MODO ALTA --->
	<!--- En esta consulta se definen los valores por defecto para los campos del encabezado en MODO ALTA --->
	<cfquery name="rsPCE" datasource="#Session.DSN#">
		select '' as PCEcodigo, '' as PCEdescripcion, 0.00 as PCElongitud, 
				0 as PCEempresa, 0 as PCEoficina, 0 as PCEvaloresxmayor,
				0 as PCEref, 0 as PCEreferenciarMayor, 0 as PCEreferenciar, 0 as PCEactivo
		from dual
	</cfquery>

	<cfquery name="rsPCEdet" datasource="#Session.DSN#">
		select 0 as Cantidad
		from dual
	</cfquery>
</cfif>

<cfquery name="rsClasificaciones" datasource="#Session.DSN#">
	select PCCEclaid, PCCEdescripcion
	  from PCClasificacionE
	 where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	   and PCCEactivo = 1
</cfquery>
<cfif isDefined("MostrarDetalle") and MostrarDetalle eq true and MODO eq "CAMBIO">
	<cfif rsPCEclas.PCCEclaid NEQ "">
		<cfquery name="rsClasificacionesD" datasource="#Session.DSN#">
			select PCCDclaid, PCCDvalor, PCCDdescripcion
			  from PCClasificacionD
			 where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPCEclas.PCCEclaid#">
			   and PCCDactivo = 1
			 order by PCCDvalor, PCCDdescripcion
		</cfquery>
	</cfif>
	<!--- Consultas del Detalle --->
	<cfif DMODO eq "CAMBIO">
		<!--- Consultas que se ejecutan solo en DMODO CAMBIO --->
		<cfquery name="rsPCD" datasource="#Session.DSN#">
			select PCDcatid, PCEcatid, PCEcatidref, Ecodigo, PCDactivo, PCDvalor, PCDdescripcion, PCDdescripcionA, Usucodigo, Ulocalizacion, ts_rversion
			from PCDCatalogo
			where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">
		</cfquery>
		<cfif rsPCD.RecordCount neq 1>
			<cfif rsPCD.RecordCount lt 1>
				<cfset url.errMsg = "La consulta del detalle del catálogo no produjo ningun resultado.">
			<cfelse>
				<cfset url.errMsg = "La consulta del detalle del catálogo produjo mas de 1 resultado.">
			</cfif>
			<cfthrow message="#url.errMsg#">
		</cfif>
		<cfquery name="rsPCDclas" datasource="#Session.DSN#">
			select PCCDclaid
			  from PCDClasificacionCatalogo
			where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">
			<!--- Esta tabla no tiene Ecodigo
			<cfif rsPCEclas.PCCEempresa EQ 1>
			  and Ecodigo = #session.Ecodigo#
			</cfif>
			--->
		</cfquery>
	<cfelse>
		<!--- Consultas que se ejecutan solo en DMODO ALTA --->
		<cfquery name="rsPCD" datasource="#Session.DSN#">
			select '' as PCEcatidref, '' as Ecodigo, 0 as PCDactivo, '' as PCDvalor, '' as PCDdescripcion, '' as PCDdescripcionA
			from dual
		</cfquery>
	</cfif>
	<!--- Consultas que se ejecutan en cualquier DMODO --->
	<cfquery name="rsPCElista" datasource="#Session.DSN#">
		select PCEcatid, PCEcodigo, PCEdescripcion, PCElongitud, PCEempresa, PCEvaloresxmayor
		from PCECatalogo
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and PCEactivo = 1
		and PCEref = 1
		and not PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEcatid#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//Funciones que utilizan el objeto Qform.
	function deshabilitar(who)	{
		if (who==0||who==2)	{
			objForm.PCEcodigo.required = false;
			objForm.PCElongitud.required = false;
			objForm.PCEdescripcion.required = false;
		}
		if (who==1||who==2)	{
			<cfif MODO eq "CAMBIO">
				objForm.PCEcatidref.required = false;
				objForm.PCDvalor.required = false;
				objForm.PCDdescripcion.required = false;
				objForm.PCDactivo.required = false;
				<cfif rsPCEclas.PCCEclaid NEQ "">
					objForm.PCCDclaid.required = false;
				</cfif>
			</cfif>
		}
	}
	function deshabilitarValidacion(obj) {
		if (obj.name=='Baja') {
			//deshabilitar todos
			deshabilitar(2);
		} else if (obj.name=='Nuevo') {
			//deshabilitar todos
			deshabilitar(2);
		} else if (obj.name=='DBaja') {
			//deshabilitar todos
			deshabilitar(1);
		} else if (obj.name=='DNuevo') {
			//deshabilitar todos
			deshabilitar(1);
		} else if (obj.name=='Cambio') {
			//deshabilitar todos
			deshabilitar(1);
		} else if (obj.name=='btnLista') {
			//deshabilitar todos
			deshabilitar(1);
			deshabilitar(2);
		}
	}

	function validar(){
		document.form1.PCEempresa.disabled = false;
		document.form1.PCElongitud.disabled = false;
		document.form1.PCEvaloresxmayor.disabled = false;
		document.form1.PCEreferenciar.disabled = false;
		document.form1.PCEreferenciarMayor.disabled = false;
		document.form1.PCEoficina.disabled = false;
		
		<cfif isdefined("Form.IncVal")>
			document.form1.PCEactivo.disabled = false;
			document.form1.PCEref.disabled = false;			
			document.form1.PCCEclaid.disabled = false;
		</cfif>			
		return true;
	}
	
	function goValores() {
		document.form1.action = 'ValoresxOficinas.cfm';
		document.form1.submit();
	}
	
	function goCuentasMayor() {
		document.form1.action = 'CuentasRefMayor.cfm';
		document.form1.submit();
	}
	function goCuentasxMayor() {
		document.form1.action = 'CuentasxMayor.cfm';
		document.form1.submit();
	}
</script>
<form action="Catalogos-sql.cfm" method="post" name="form1" onSubmit="return validar();" style="margin:0;">
<!--- campos ocultos para mantener la navegacion --->
<cfoutput>
<input type="hidden" name="Pagina2" value="#form.Pagina2#" tabindex="-1" />
<input type="hidden" name="F_PCDvalor" value="#form.F_PCDvalor#" tabindex="-1" />
<input type="hidden" name="F_PCDdescripcion" value="#form.F_PCDdescripcion#" tabindex="-1" />

<cfif isdefined("Form.IncVal")>
	<input name="IncVal" type="hidden" id="IncVal" value="#Form.IncVal#"/>
</cfif>

</cfoutput>
<!--------------------------------------------------ENCABEZADO--------------------------------------------------------------->
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0;">
    <tr>
      	<td nowrap colspan="4">
			<cfif MODO eq "CAMBIO">
				<input type="hidden" name="PCEcatid" value="<cfoutput>#rsPCE.PCEcatid#</cfoutput>" tabindex="-1">
				<cfset ts = "">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsPCE.ts_rversion#" returnvariable="ts">				</cfinvoke>
				<input type="hidden" name="ts_rversion" tabindex="-1" value="<cfoutput>#ts#</cfoutput>">
			</cfif>
			<div align="center" class="tituloAlterno">Encabezado del Cat&aacute;logo</div>		</td>
    </tr>
    <tr>
      <td height="20" colspan="4" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td width="16%" nowrap valign="bottom"><div align="right">C&oacute;digo &nbsp;&nbsp;</div></td>
      <td width="52%" nowrap valign="bottom">

		<input name="PCEcodigo" type="text" id="PCEcodigo" value="<cfoutput>#Trim(rsPCE.PCEcodigo)#</cfoutput>" maxlength="10" tabindex="1" <cfoutput>#BlockCamposInput#</cfoutput>>
	  	<span align="left"> 
			<cfif rsPCEdet.Cantidad GT 0>
				<cfif (rsPCE.PCEempresa EQ 0)>
					Catálogo Corporativo
					<input type="hidden" name="PCEempresa" value="0">
				<cfelse>
					Catálogo Empresarial (Valores por Empresa)
					<input type="hidden" name="PCEempresa" value="1">
				</cfif>
			<cfelse>
				<input name="PCEempresa" type="checkbox" id="PCEempresa" 
					<cfif (#rsPCE.PCEempresa# EQ 1)>checked</cfif> 
					value="1" onclick="javascript:MostrarOf('etiquetaof',this.checked)" tabindex="1">
				Valores por Empresa		
			</cfif> 
		</span>
		&nbsp;&nbsp;
		<cfif (#rsPCE.PCEempresa# EQ 0)>
			<cfset rsPCE.PCEoficina = 0>
			<cfset rsPCE.PCEreferenciarMayor = 0>
		</cfif>
		<span <cfif (#rsPCE.PCEempresa# EQ 0)>style="visibility:hidden;"</cfif> align="left" id="etiquetaof"> 
		    <input name="PCEoficina" type="checkbox" id="PCEoficina" value="1" <cfif modo eq "CAMBIO" and isdefined("rsOficinas") and rsOficinas.recordcount gt 0>disabled</cfif> tabindex="1"  <cfif (#rsPCE.PCEoficina# EQ 1)>checked</cfif>>
			Valores por Oficina		</span>	  </td>
      <td width="5%" nowrap ><div align="right"></div></td>
      <td width="27%" nowrap >

	  	<table align="left" cellpadding="0" cellspacing="0">
		<tr>
			<td colspan="2">
				<div align="left" >
					<input <cfif (#rsPCE.PCEreferenciar# EQ 1)>checked</cfif>   name="PCEreferenciar" type="checkbox" id="PCEreferenciar" onclick="javascript:MostrarOf('etiquetaref', this.checked)" value="checkbox" tabindex="1"  <cfif modo eq "CAMBIO" and isdefined("modificable")><cfoutput>#modificable#</cfoutput></cfif>	>
					Debe Referenciar (es Padre)	
				</div>	
				 
			</td>	
							
		</tr>		
		<tr>		
			<td width="20"></td>
			<td>						
				<span <cfif (#rsPCE.PCEempresa# EQ 0 OR rsPCE.PCEreferenciar EQ 0)>style="visibility:hidden;"</cfif> align="left" id="etiquetaref"> 
				<input name="PCEreferenciarMayor" type="checkbox" id="PCEreferenciarMayor" value="1" <cfif modo eq "CAMBIO" and isdefined("modificableMayor")><cfoutput>#modificableMayor#</cfoutput></cfif> tabindex="1" <cfif (#rsPCE.PCEreferenciarMayor# EQ 1)>checked</cfif>> <!--- onClick="javascript:verificaEstadoPadre(document.form1.PCEreferenciar,this)"> --->
				Permite referencia por Mayor				</span>			</td>				
		</tr>
		</table>	  </td>
    </tr>
    <tr>
      <td nowrap ><div align="right" >Longitud: &nbsp;&nbsp;</div></td>
      <td nowrap >
	    <input name="PCElongitud" type="text" id="PCElongitud" tabindex="1" value="<cfif modo eq "CAMBIO" and isdefined("rsPCE")><cfoutput>#Int(rsPCE.PCElongitud)#</cfoutput></cfif>" maxlength="9" <cfif rsPCEdet.Cantidad GT 0>readonly</cfif>>
	  	<input <cfif (#rsPCE.PCEvaloresxmayor# EQ 1)>checked</cfif> name="PCEvaloresxmayor" type="checkbox" id="PCEvaloresxmayor" value="checkbox" tabindex="1" <cfif modo eq "CAMBIO" and isdefined("rsMayor") and rsMayor.total gt 0>disabled</cfif>>
        Valores por Cuenta Mayor	  </td>
      <td nowrap ><div align="right"></div></td>
      <td nowrap >
	  	<div align="left"> <input <cfif rsPCE.PCEref EQ 1>checked</cfif> name="PCEref" type="checkbox" id="PCEref" value="checkbox" tabindex="1">
        	Puede ser Referenciado (es Hijo)		</div>	  </td>
    </tr>
    <tr>
      <td nowrap ><div align="right" >Descripci&oacute;n: &nbsp;&nbsp;</div></td>
      <td nowrap ><input name="PCEdescripcion" type="text" id="PCEdescripcion" value="<cfoutput>#Trim(rsPCE.PCEdescripcion)#</cfoutput>" size="60" maxlength="80" tabindex="1" <cfoutput>#BlockCamposInput#</cfoutput>></td>
      <td nowrap ><div align="right"></div></td>
      <td nowrap ><div align="left"> <input <cfif rsPCE.PCEactivo EQ 1>checked<cfelseif modo eq 'ALTA'>checked</cfif> name="PCEactivo" type="checkbox" id="PCEactivo" value="checkbox" tabindex="1">
        Activo</div></td>
    </tr>
    <tr>
      <td nowrap ><div align="right">Clasificar por: &nbsp;&nbsp;</div></td>
      <td nowrap >
	  	<select name="PCCEclaid" tabindex="1">
			<option value="">(Sin Clasificar)</option>
			<cfoutput query="rsClasificaciones">
			<option value="#PCCEclaid#" <cfif MODO NEQ "ALTA" AND rsClasificaciones.PCCEclaid EQ rsPCEclas.PCCEclaid>selected</cfif>>#PCCEdescripcion#</option>
			</cfoutput>			
		</select> </td>
     	<td nowrap >&nbsp;</td>
    	<td nowrap >
			<cfif MODO NEQ "ALTA" and not isdefined("Form.IncVal")>
				<BR><input name="Usuarios_Adm" type="button" id="Usuarios_Adm" class="btnNormal" value="Usuarios Adm." tabindex="2" onclick="javascript: ingresaUsu();"/></BR>
			</cfif>
		</td>
    </tr>
	<!--------------------------------------------------DETALLE----------------------------------------------------------------->
	<cfif isDefined("MostrarDetalle") and MostrarDetalle eq true and MODO eq "CAMBIO">
	<cfset LvarDetReadOnly = "no">
	<cfif DMODO NEQ "ALTA">
		<cfquery name="rsCubo" datasource="#Session.DSN#">
			select count(1) as cantidad
			from PCDCatalogoCuentaF
			where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">
		</cfquery>
		<cfif rsCubo.cantidad NEQ "" AND rsCubo.cantidad NEQ 0>
			<cfset LvarDetReadOnly = "yes">
		</cfif>
		<cfquery name="rsCubo" datasource="#Session.DSN#">
			select count(1) as cantidad
			from PCDCatalogoCuenta
			where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">
		</cfquery>
		<cfif rsCubo.cantidad NEQ "" AND rsCubo.cantidad NEQ 0>
			<cfset LvarDetReadOnly = "yes">
		</cfif>
		<cfquery name="rsCubo" datasource="#Session.DSN#">
			select count(1) as cantidad
			from PCDCatalogoCuentaP
			where PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCDcatid#">
		</cfquery>
		<cfif rsCubo.cantidad NEQ "" AND rsCubo.cantidad NEQ 0>
			<cfset LvarDetReadOnly = "yes">
		</cfif>
	</cfif>
	
    <cfif DMODO eq "CAMBIO">
		<input type="hidden" name="PCDcatid" value="<cfoutput>#rsPCD.PCDcatid#</cfoutput>" tabindex="-1">
		<cfset tsd = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsPCD.ts_rversion#" returnvariable="tsd"></cfinvoke>
		<input type="hidden" name="dtimestamp" value="<cfoutput>#tsd#</cfoutput>" tabindex="-1">
	</cfif>
	  <tr>
        <td nowrap colspan="4">&nbsp;</td>
      </tr>
      <tr>
        <td nowrap colspan="4">
			<div align="center" class="tituloAlterno">
            	Detalle del Cat&aacute;logo			</div>		</td>
      </tr>
	  <tr>
        <td nowrap colspan="4">&nbsp;</td>
      </tr>
      <tr>
        <td nowrap colspan="4">

          <!--- INICIA PINTADO DEL DETALLE --->
          <div align="left">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td nowrap ><div align="left">Valor</div></td>
                <td nowrap ><div align="left">Descripci&oacute;n</div></td>
				<cfif (rsPCE.PCEempresa EQ 0)>
	                <td nowrap ><div align="left">Descripci&oacute;n Alterna</div></td>
				</cfif>
				<td nowrap >
					<cfif isdefined("rsPCE.PCEreferenciar") and rsPCE.PCEreferenciar neq 0>
						<div align="left">Cat&aacute;logo Referenciado (si no hay X Cta Mayor)</div>
					<cfelse>
						&nbsp;
					</cfif>
				</td>
                <td nowrap ><div align="center">Activo</div></td>
              </tr>
              <tr>
					<td nowrap >
						<div align="left">
							<input name="PCDvalor" type="text" tabindex="2" id="PCDvalor" value="<cfoutput>#Trim(rsPCD.PCDvalor)#</cfoutput>" maxlength="<cfif isdefined("rsPCE.PCElongitud") and len(rsPCE.PCElongitud) gt 0><cfoutput>#rsPCE.PCElongitud#</cfoutput></cfif>" onblur="this.value=('0000000000'+this.value).substring(10+this.value.length-<cfoutput>#rsPCE.PCElongitud#</cfoutput>);" <cfif LvarDetReadOnly NEQ "no">readonly</cfif>>
						</div>
					</td>
					<td nowrap>
						<div align="left">
							<input name="PCDdescripcion" type="text" tabindex="2" id="PCDdescripcion" value="<cfoutput>#Trim(rsPCD.PCDdescripcion)#</cfoutput>" size="55" maxlength="80">
						</div>					
					</td>
				<cfif (rsPCE.PCEempresa EQ 0)>
					<td nowrap>
						<div align="left">
							<input name="PCDdescripcionA" type="text" tabindex="2" id="PCDdescripcionA" value="<cfoutput>#Trim(rsPCD.PCDdescripcionA)#</cfoutput>" size="55" maxlength="80">
						</div>					
					</td>
				</cfif>
					<td nowrap>
						<cfif rsPCE.PCEreferenciar EQ "1">
								<div align="left" style="white-space: nowrap;">
								<cfif isdefined('DMODO') and DMODO NEQ 'ALTA' and #rsPCD.PCEcatidref# neq "">
									<cfquery name="rsD_PCEcatid" datasource="#Session.DSN#">
										select PCEcatid as PCEcatidref,
												PCEcodigo as D_PCEcodigo,
												PCEdescripcion as D_PCEdescripcion
										from PCECatalogo
										where CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
											and PCEcatid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPCD.PCEcatidref#">
									</cfquery>
			
									<cf_sifcatalogos name="PCEcatidref" llave="#Form.PCEcatid#" codigo="D_PCEcodigo" desc="D_PCEdescripcion" query="#rsD_PCEcatid#" form="form1" Conexion="#Session.DSN#" readonly="#LvarDetReadOnly#" tabindex="2">
								<cfelse>
									<cf_sifcatalogos name="PCEcatidref" llave="#Form.PCEcatid#" codigo="D_PCEcodigo" desc="D_PCEdescripcion" form="form1" Conexion="#Session.DSN#" tabindex="2">
								</cfif>
								</div>
							<!--- <cfelse> --->
							<!---
							<select name="PCEcatidref" id="PCEcatidref">
								<option value="null" <cfif (isDefined("rsPCD.PCEcatidref") AND "null" EQ rsPCD.PCEcatidref)>selected</cfif>>Ninguno</option>
								<cfoutput query="rsPCElista">
								  <option value="#rsPCElista.PCEcatid#" <cfif (isDefined("rsPCD.PCEcatidref") AND rsPCElista.PCEcatid EQ rsPCD.PCEcatidref)>selected</cfif>>#rsPCElista.PCEdescripcion#</option>
								</cfoutput>
							  </select>
								--->
								
								<!--- </td>								
								<td nowrap> --->
			
							<!--- </cfif> --->
						<cfelse>
							&nbsp;<input type="hidden" name="PCEcatidref" id="PCEcatidref" value="" tabindex="-1">
						</cfif>					</td>
					<td nowrap >
						<div align="center">
						<input name="PCDactivo" type="checkbox" id="PCDactivo" tabindex="2" value="checkbox" <cfif rsPCD.PCDactivo EQ 1>checked<cfelseif dmodo eq 'ALTA'>checked</cfif>>
						</div>					</td>
              </tr>
			  <cfif DMODO NEQ "ALTA">
			  <tr>
			  		<td></td><td>
						<cfparam name="session.chkCFdesc" default="0">
						<input type="checkbox" name="chkCFdesc" value="1" <cfif session.chkCFdesc EQ 1>checked</cfif>/>
						Cambiar descripción de Cuentas Financieras
					</td>
              </tr>
			  </cfif>
			  <cfif MODO NEQ "ALTA" AND rsPCEclas.PCCEclaid NEQ "">
			  <tr>
					<td>&nbsp;</td>
					<td align="right">
						<cfoutput>#rsPCEclas.PCCEdescripcion#</cfoutput>:&nbsp;&nbsp;					</td>
					<td>
						<select name="PCCDclaid" tabindex="2">
							<option value="">(Sin Clasificar)</option>
							<cfoutput query="rsClasificacionesD">
							<option value="#PCCDclaid#" <cfif DMODO eq "CAMBIO" AND rsClasificacionesD.PCCDclaid EQ rsPCDclas.PCCDclaid>selected</cfif>>#PCCDvalor# - #PCCDdescripcion#</option>
							</cfoutput>
						</select>					</td>
				</tr>
			  </cfif>
            </table>
            <!--- FINALIZA PINTADO DEL DETALLE --->
          </div></td>
      </tr>
    </cfif>
<!--------------------------------------------------BOTONES----------------------------------------------------------------->
    <tr>
      <td nowrap colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td nowrap colspan="4"><div align="center">

			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
			<input type="hidden" name="botonSel" value="" tabindex="-1">
			<cfif isDefined("MostrarDetalle") and MostrarDetalle eq true and MODO eq "CAMBIO">
				<!--- DEFINE BOTONES PARA ENCABEZADO Y DETALLE EN MODO CAMBIO--->
				<cfif DMODO eq "ALTA">
						<input type="submit" name="DAlta" 	class="btnGuardar" 	value="Agregar" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name;">
						<input type="reset"  name="Limpiar" class="btnLimpiar"	value="Limpiar" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name;">
					<cfif not isdefined("Form.IncVal")>
						<!--- Si la variable no está definida es porque fue llamado desde el Catálogo del plan de cuentas 
						      de otra forma el llamado se hizo desde la inclusion de valores--->
						<input type="submit" name="Cambio" class="btnGuardar"  value="Modificar Catálogo" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;">
						<input type="submit" name="Baja"   class="btnEliminar" value="Eliminar Catálogo"  tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('¿Desea eliminar el encabezado y todos sus detalles?')){return false;}else{deshabilitarValidacion(this); return true;}">
						<input type="submit" name="Nuevo"  class="btnNuevo"    value="Nuevo Catálogo" 	  tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;">
					</cfif>
				<cfelse>
					<input type="submit" name="DCambio"    class="btnGuardar"  value="Modificar" 		tabindex="2" onClick="javascript: this.form.botonSel.value = this.name;">
					<input type="submit" name="DBaja" 	   class="btnEliminar" value="Eliminar detalle" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('¿Desea eliminar el detalle?')){return false;}else{deshabilitarValidacion(this); return true;}">
					<input type="submit" name="DNuevo" 	   class="btnNuevo"    value="Nuevo detalle" 	tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;">
					<cfif not isdefined("Form.IncVal")>
						<!--- Si la variable no está definida es porque fue llamado desde el Catálogo del plan de cuentas 
						      de otra forma el llamado se hizo desde la inclusion de valores--->					
						<input type="submit" name="Baja"  class="btnEliminar" value="Eliminar Catálogo" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; if (!confirm('¿Desea eliminar el encabezado y todos sus detalles?')){return false;}else{deshabilitarValidacion(this); return true;}">
					</cfif>
				</cfif>
            <cfelse>
				<!--- DEFINE BOTONES PARA ENCABEZADO EN MODO ALTA--->
				<input type="submit" name="Alta" 		 class="btnGuardar" value="Agregar" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name;">
				<input type="reset"  name="Limpiar" 	 class="btnLimpiar" value="Limpiar" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name;">
				
			</cfif>
			<cfif MODO NEQ "ALTA">
			<input type="button" name="btnImprime" class="btnimprimir" value="Imprimir" onClick="javascript: ConlisReporte('pdf');">
			<input type="button" name="btnImprime2" class="btnGuardar" value="Descargar" onClick="javascript: ConlisReporte2('excel');">
			</cfif>
		  	<BR>				
			<input type="submit" name="btnLista" class="btnAnterior"	value="Ir a Lista" tabindex="2" onClick="javascript: this.form.botonSel.value = this.name; deshabilitarValidacion(this); return true;">
        	<cfif isdefined("rsPCE.PCEoficina") and rsPCE.PCEoficina EQ "1" and dmodo eq "CAMBIO">
				<input type="button" name="btnValoresxOficina" value="Oficinas por Valor" tabindex="2" onClick="javascript: goValores();">
			</cfif>
			<cfif isdefined("rsPCE.PCEreferenciar") 
			  and rsPCE.PCEreferenciar eq "1" 
			  and isdefined("rsPCE.PCEreferenciarMayor")
			  and rsPCE.PCEreferenciarMayor eq "1" 
			  and dmodo eq "CAMBIO">				
				<input name="MayorRef" type="button" id="MayorRef" value="Catalogos x Mayor" tabindex="2" onClick="javascript: goCuentasMayor();">				
			</cfif>	
			<cfif isdefined("rsPCE.PCEvaloresxmayor") 
			  and rsPCE.PCEvaloresxmayor eq "1" 
			  and dmodo eq "CAMBIO">
				<input name="CtaxMayor" type="button" id="CtaxMayor" value="Cuentas de Mayor" tabindex="2" onClick="javascript: goCuentasxMayor();">				
			</cfif>	
		</div></td>
    </tr>
</table>
</form>

<cfif isDefined("MostrarDetalle") and MostrarDetalle eq true and MODO eq "CAMBIO">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin:0;">
 <!--------------------------------------------------DETALLE----------------------------------------------------------------->
      <tr>
        <td nowrap colspan="4">&nbsp;</td>
      </tr>

      <tr>
        <td nowrap colspan="4"><div align="center" class="tituloAlterno">Lista de Detalles del Cat&aacute;logo</div></td>
      </tr>

      <tr>
        <td nowrap colspan="4" align="center">
		  <form style="margin:0;" name="formFiltro" method="post" action="Catalogos.cfm">
				<cfif MODO eq "CAMBIO">
					<input type="hidden" name="PCEcatid" value="<cfoutput>#rsPCE.PCEcatid#</cfoutput>" tabindex="-1">
					<input type="hidden" name="MODO" value="<cfoutput>#MODO#</cfoutput>" tabindex="-1">
				</cfif>
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="areaFiltro">
				<tr>
					<td><strong>Valor</strong></td>
					<td><strong>Descripci&oacute;n</strong></td>
					<cfif isdefined("#rsPCE.PCEreferenciar#") and #rsPCE.PCEreferenciar# EQ 1 >
						<td><strong>Cat&aacute;logo Referenciado</strong></td>
					<cfelse>
						<cfif isdefined("#rsPCE.PCEreferenciar#") and #rsPCE.PCEreferenciar# EQ 1 and isdefined("#rsPCE.PCEreferenciarMayor#") and #rsPCE.PCEreferenciarMayor# EQ 1>
						<td><strong>Cat&aacute;logo Referenciado x Mayor</strong></td>
						</cfif>
					</cfif>
					<cfif isdefined("rsOficinas") and rsOficinas.recordcount gt 0 and isdefined("rsPCE.PCEoficina") and rsPCE.PCEoficina EQ 1>
						<td><strong>Oficina</strong></td>
					</cfif>
					<!---<td><strong>Activo</strong></td>--->
					<td rowspan="2" align="center" valign="middle"><input name="btnFiltrar" type="submit" id="btnFiltrar" class="btnFiltrar" value="Filtrar" tabindex="3"></td>
				</tr>
				<tr>
					<td>
						<input name="F_PCDvalor" type="text" id="F_PCDvalor" tabindex="2"
							value="<cfif isdefined('form.F_PCDvalor') and form.F_PCDvalor NEQ ""><cfoutput>#form.F_PCDvalor#</cfoutput></cfif>" 
							maxlength="20"
							>
					</td>
					<td><input name="F_PCDdescripcion" type="text" id="F_PCDdescripcion" tabindex="2" value="<cfif isdefined('form.F_PCDdescripcion') and form.F_PCDdescripcion NEQ ""><cfoutput>#form.F_PCDdescripcion#</cfoutput></cfif>" size="60" maxlength="80"></td>
					<cfif isdefined("#rsPCE.PCEreferenciar#") and #rsPCE.PCEreferenciar# EQ 1>
					<td>
						<cfif isdefined('form.F_PCEcatidref') and form.F_PCEcatidref NEQ '' and isdefined('form.F_PCEcodigo') and form.F_PCEcodigo NEQ ''>
							<cfquery name="rsF_PCEcatid" datasource="#Session.DSN#">
								select PCEcatid as F_PCEcatidref,
										PCEcodigo as F_PCEcodigo,
										PCEdescripcion as F_PCEdescripcion
								from PCECatalogo
								where CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
									and PCEcatid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.F_PCEcatidref#">
							</cfquery>

							<cf_sifcatalogos name="F_PCEcatidref" frame="filtroFrame" llave="#Form.PCEcatid#" codigo="F_PCEcodigo" desc="F_PCEdescripcion" query="#rsF_PCEcatid#" form="formFiltro" Conexion="#Session.DSN#" tabindex="2">
						<cfelse>
							<cf_sifcatalogos name="F_PCEcatidref" frame="filtroFrame" llave="#Form.PCEcatid#" codigo="F_PCEcodigo" desc="F_PCEdescripcion" form="formFiltro" Conexion="#Session.DSN#" tabindex="2">
						</cfif>
					</td>
					<cfelse>
						<cfif isdefined("#rsPCE.PCEreferenciar#") and #rsPCE.PCEreferenciar# EQ 1 and isdefined("#rsPCE.PCEreferenciarMayor#") and #rsPCE.PCEreferenciarMayor# EQ 1>
							<td><input type="button" name="catpormayor" value="Catalogos x Mayor" onClick="" tabindex="2"></td>
						</cfif>
					</cfif>
					<cfif isdefined("rsPCE.PCEoficina") and rsPCE.PCEoficina EQ "1">
						
						<cfif isdefined("rsOficinas") and rsOficinas.recordcount gt 0>
						<td>
							<select name="cboOficinas" tabindex="2">
							<cfif not isdefined("form.cboOficinas")>
								<option value="-1">No importa</option>
								<cfoutput query="rsOficinas">
								<option value="#Ocodigo#">#Odescripcion#</option>
								</cfoutput>
							<cfelse>
								<cfif form.cboOficinas eq -1>
									<option value="-1" selected>No importa</option>
									<cfoutput query="rsOficinas">
									<option value="#Ocodigo#">#Odescripcion#</option>
									</cfoutput>								
								<cfelse>
									<option value="-1" selected>No importa</option>
									<cfoutput query="rsOficinas">
										<cfif rsOficinas.Ocodigo eq form.cboOficinas>
											<option value="#Ocodigo#" selected>#Odescripcion#</option>
										<cfelse>
											<option value="#Ocodigo#">#Odescripcion#</option>
										</cfif>
									</cfoutput>									
								</cfif>
							</cfif>							
							</select>
						</td>
						</cfif>
						
					</cfif>					
					<!---<td align="center"><input class="areaFiltro" name="F_PCDactivo" type="checkbox" id="F_PCDactivo" value="checkbox" <cfif isdefined('form.F_PCDactivo')>checked</cfif>></td>--->
				  </tr>
				  </table>

		  </form>
		</td>
      </tr>


      <tr>
      <td nowrap colspan="4">
		<cfset porEmpresa = IIf(isDefined("rsPCE.PCEempresa") AND rsPCE.PCEempresa eq 1, DE("and a.Ecodigo = #Session.Ecodigo#"), DE(""))>
<!---

Select a.PCEcatid,
	PCDcatid,
	coalesce(b.PCEdescripcion,'Ninguno') as PCEdescripcion,
	case PCDactivo
                when 1 then 'Sí' else 'No' end as PCDactivo,
        PCDvalor,
        PCDdescripcion,
	case coalesce((   select count(1) from PCDCatalogoRefMayor d
                                  where d.PCDcatid=a.PCDcatid),0)
                when 0 then 'No' else 'Sí' end as PCDcatidrefMayor,
            'CAMBIO' as DMODO
from PCDCatalogo a
    left outer join PCECatalogo b
        on a.PCEcatidref = b.PCEcatid
where  a.PCEcatid = 19
    and Ecodigo=1 --->
	

			<cfset LvarIncVal = "">
			<cfif isdefined("Form.IncVal")>
				<cfset LvarIncVal = '1 as IncVal'>
			</cfif>

			<cfif not isdefined("form.cboOficinas")>
				<cfinvoke
				 component="sif.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="PCDCatalogo a
															left outer join PCECatalogo b
																on a.PCEcatidref = b.PCEcatid
															left outer join PCDClasificacionCatalogo c
																inner join PCClasificacionD d
																	on c.PCCDclaid = d.PCCDclaid
																on a.PCDcatid = c.PCDcatid
														"/>			
					<cfinvokeargument name="columnas" value="'#Form.F_PCDvalor#' as F_PCDvalor,
																'#Form.F_PCDdescripcion#' as F_PCDdescripcion,
																'#Form.F_PCEcatidref#' as F_PCEcatidref,
																'#LvarIncVal#' AS V1,
																a.PCEcatid,
																a.PCDcatid,
																d.PCCDvalor,													
																coalesce(b.PCEdescripcion,'Ninguno') as PCEdescripcion,
																case PCDactivo
																			when 1 then 'Sí' else 'No' end as PCDactivo,
																	PCDvalor,
																	PCDdescripcion,
																case coalesce((   select count(1) from PCDCatalogoRefMayor e
																							  where e.PCDcatid=a.PCDcatid),0)
																			when 0 then 'No' else 'Sí' end as PCDcatidrefMayor,
																		'CAMBIO' as DMODO"/>
					<cfinvokeargument name="desplegar" value="PCDvalor, PCDdescripcion, PCCDvalor, PCEdescripcion, PCDcatidrefMayor, PCDactivo"/>
					<cfinvokeargument name="etiquetas" value="Valor, Descripción, Clasif.&nbsp;, Catálogo Referenciado, Catálogos x Cta.Mayor, Activo"/>
					<cfinvokeargument name="formatos" value="S, S, S, S, S, S"/>
					<cfinvokeargument name="filtro" value="a.PCEcatid = #Form.PCEcatid# #porEmpresa# #filtro#  order by PCDvalor"/>
					<cfinvokeargument name="align" value="left, left, center, left, center, center"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="irA" value="Catalogos.cfm"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="keys" value="PCEcatid,PCDcatid"/>
					<cfinvokeargument name="PageIndex" value="2"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
				</cfinvoke>
				<cfelse>	
				<!--- -- 					and a.PCEcatidref *= b.PCEcatid
								----Elimine el ALTER JOIN para que funcionara el filtro
				 --->
				<cfif cboOficinas gt -1>

						<cfinvoke
						 component="sif.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="PCDCatalogo a
																   inner join PCECatalogo b
																		on a.PCEcatid = b.PCEcatid
				
																   left outer join PCDClasificacionCatalogo d
																   inner join PCClasificacionD e
																		on d.PCCDclaid = e.PCCDclaid
																		on a.PCDcatid = d.PCDcatid
				
																   left outer join PCDCatalogoValOficina c
																		on a.PCDcatid = c.PCDcatid
																		and c.Ocodigo  = #cboOficinas#"/>
																		
							<cfinvokeargument name="columnas" value="'#Form.F_PCDvalor#' as F_PCDvalor,
																	 '#Form.F_PCDdescripcion#' as F_PCDdescripcion,
																	 '#Form.F_PCEcatidref#' as F_PCEcatidref,
																	 '#LvarIncVal#' AS V1,
																	 a.PCEcatid,
																	 a.PCDcatid,
																	 e.PCCDvalor,													
																	 coalesce(b.PCEdescripcion,'Ninguno') as PCEdescripcion,
																	 case PCDactivo
																		when 1 then 'Sí' else 'No' end as PCDactivo,
																	 PCDvalor,
																	 PCDdescripcion, case when c.Ocodigo is not null then 'SI' else 'No' end as TieneOfi, 
																	 case coalesce(( select count(1) 
																					 from PCDCatalogoRefMayor e
																					 where e.PCDcatid=a.PCDcatid),0)
																	 when 0 then 'No' else 'Sí' end as PCDcatidrefMayor,
																	'CAMBIO' as DMODO"/>
							<cfinvokeargument name="desplegar" value="PCDvalor, PCDdescripcion, PCCDvalor, PCEdescripcion, PCDcatidrefMayor, PCDactivo, TieneOfi"/>
							<cfinvokeargument name="etiquetas" value="Valor, Descripción, Clasif.&nbsp;, Catálogo Referenciado, Catálogos x Cta.Mayor, Activo, Pertenece a Oficina"/>
							<cfinvokeargument name="formatos" value="S, S, S, S, S, S, S"/>
							<cfinvokeargument name="filtro" value="a.PCEcatid = #Form.PCEcatid# #porEmpresa# #filtro#  order by PCDvalor"/>
							<cfinvokeargument name="align" value="left, left, center, left, center, center, center"/>
							<cfinvokeargument name="ajustar" value="S"/>
							<cfinvokeargument name="irA" value="Catalogos.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>		 
			
				<cfelse>

						<cfinvoke
						 component="sif.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="PCDCatalogo a
																	left outer join PCECatalogo b
																		on a.PCEcatidref = b.PCEcatid
																	left outer join PCDClasificacionCatalogo c
																		inner join PCClasificacionD d
																			on c.PCCDclaid = d.PCCDclaid
																		on a.PCDcatid = c.PCDcatid
																"/>			
							<cfinvokeargument name="columnas" value="'#Form.F_PCDvalor#' as F_PCDvalor,
																		'#Form.F_PCDdescripcion#' as F_PCDdescripcion,
																		'#Form.F_PCEcatidref#' as F_PCEcatidref,
																		'#LvarIncVal#' as V1,
																		a.PCEcatid,
																		a.PCDcatid,
																		d.PCCDvalor,													
																		coalesce(b.PCEdescripcion,'Ninguno') as PCEdescripcion,
																		case PCDactivo
																					when 1 then 'Sí' else 'No' end as PCDactivo,
																			PCDvalor,
																			PCDdescripcion,
																		case coalesce((   select count(1) from PCDCatalogoRefMayor e
																									  where e.PCDcatid=a.PCDcatid),0)
																					when 0 then 'No' else 'Sí' end as PCDcatidrefMayor,
																				'CAMBIO' as DMODO"/>
							<cfinvokeargument name="desplegar" value="PCDvalor, PCDdescripcion, PCCDvalor, PCEdescripcion, PCDcatidrefMayor, PCDactivo"/>
							<cfinvokeargument name="etiquetas" value="Valor, Descripción, Clasif.&nbsp;, Catálogo Referenciado, Catálogos x Cta.Mayor, Activo"/>
							<cfinvokeargument name="formatos" value="S, S, S, S, S, S"/>
							<cfinvokeargument name="filtro" value="a.PCEcatid = #Form.PCEcatid# #porEmpresa# #filtro#  order by PCDvalor"/>
							<cfinvokeargument name="align" value="left, left, center, left, center, center"/>
							<cfinvokeargument name="ajustar" value="S"/>
							<cfinvokeargument name="irA" value="Catalogos.cfm"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="keys" value="PCEcatid,PCDcatid"/>
							<cfinvokeargument name="PageIndex" value="2"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
						</cfinvoke>				
						
				</cfif>
				
			</cfif>	 
		</td>
      </tr>
	</table>
</cfif>

<cfif DEBUG>
	<cfdump var="#Form#" expand="no" label="Form">
	<cfdump var="#Url#" expand="no" label="Url">
	<cfdump var="#Session#" expand="no" label="Session">
</cfif>
<!--- Valores q se pasan para la exportacion a PDF o excel --->
<cfif (#rsPCE.PCEempresa# EQ 1)>
  <cfset PCEempresa = "SI" >
<cfelse>
  <cfset PCEempresa = "NO" >   
</cfif>

<cfif (#rsPCE.PCEoficina# EQ 1)>
  <cfset PCEoficina = "SI" >
<cfelse>
  <cfset PCEoficina = "NO" >   
</cfif>

<cfif (#rsPCE.PCEvaloresxmayor# EQ 1)>
  <cfset PCEvaloresxmayor = "SI" >
<cfelse>
  <cfset PCEvaloresxmayor = "NO" >   
</cfif>

<cfif (#rsPCE.PCEreferenciar# EQ 1)>
  <cfset PCEreferenciar = "SI" >
<cfelse>
  <cfset PCEreferenciar = "NO" >   
</cfif>

<cfif (#rsPCE.PCEreferenciarMayor# EQ 1)>
  <cfset PCEreferenciarMayor = "SI" >
<cfelse>
  <cfset PCEreferenciarMayor = "NO" >   
</cfif>


<cfif (#rsPCE.PCEactivo# EQ 1)>
  <cfset PCEactivo = "SI" >
<cfelse>
  <cfset PCEactivo = "NO" >   
</cfif>
 
 <cfif isdefined('rsPCEclas.PCCEdescripcion') and #rsPCEclas.PCCEdescripcion# NEQ "">
  <cfset PCCEdescripcion = #rsPCEclas.PCCEdescripcion# >
<cfelse>
  <cfset PCCEdescripcion = "SIN  CLASIFICAR" >   
</cfif>

<!---<cfif isdefined('rsPCEclas.PCCEdescripcion') and #rsPCEclas.PCCEdescripcion# NEQ "">
  <cfset PCCEdescripcion = #rsPCEclas.PCCEdescripcion# >
<cfelse>
  <cfset PCCEdescripcion = "SIN  CLASIFICAR" >   
</cfif>--->
          
<!---fin ---->



<script language="JavaScript1.2" type="text/javascript">
   
    function ConlisReporte() {		
		<!---	if (confirm('Presione ACEPTAR si desea imprimir en Excel o CANCELAR para imprimir  en formato PDF')) 
				{formato = 'excel'} 
			else 
				{formato = 'pdf'}	--->	
			formato = 'pdf'		
			var params = "";
<cfoutput>
			params = 	"?btnImprime=true&formato=" + formato + 
						"&F_PCDvalor=#URLencodedFormat(Form.F_PCDvalor)#&F_PCDdescripcion=#URLencodedFormat(Form.F_PCDdescripcion)#&F_PCEcatidref=#URLencodedFormat(Form.F_PCEcatidref)#" +
						"&filtro=#URLencodedFormat(filtro)#&PCEcodigo=#URLencodedFormat(Trim(rsPCE.PCEcodigo))#&PCElongitud=#URLencodedFormat(Trim(rsPCE.PCElongitud))#" +
						"&PCEdescripcion=#URLencodedFormat(Trim(rsPCE.PCEdescripcion))#&PCEempresa=#URLencodedFormat(PCEempresa)#&PCEoficina=#URLencodedFormat(PCEoficina)#" +
						"&PCEvaloresxmayor=#URLencodedFormat(PCEvaloresxmayor)#&PCEreferenciar=#URLencodedFormat(PCEreferenciar)#&PCEreferenciarMayor=#URLencodedFormat(PCEreferenciarMayor)#" +
						"&PCEactivo=#URLencodedFormat(PCEactivo)#&PCCEdescripcion=#URLencodedFormat(PCCEdescripcion)#";
<cfif isdefined("Form.IncVal") >			params = params + "&LvarIncVal=#URLencodedFormat(LvarIncVal)#";</cfif>
<cfif isdefined("Form.PCEcatid")>			params = params + "&PCEcatid=#URLencodedFormat(Form.PCEcatid)#";</cfif>
<cfif isdefined("Form.porEmpresa")>			params = params + "&porEmpresa=#URLencodedFormat(porEmpresa)#";</cfif>

</cfoutput>
		popUpWindow("Catalogos-sql.cfm"+params,250,200,650,400);
		
	}
	var popUpWin = 0;
	
	
	  function ConlisReporte2() {		
		<!---	if (confirm('Presione ACEPTAR si desea imprimir en Excel o CANCELAR para imprimir  en formato PDF')) 
				{formato = 'excel'} 
			else 
				{formato = 'pdf'}	--->	
			formato = 'excel'		
			var params = "";
						<!---	params = "?btnImprime=true&formato="+formato+"&F_PCDvalor=<cfoutput>#Form.F_PCDvalor#</cfoutput>"+"&F_PCDdescripcion=<cfoutput>#Form.F_PCDdescripcion#</cfoutput>"+"&F_PCEcatidref=<cfoutput>#Form.F_PCEcatidref#</cfoutput><cfif isdefined("Form.IncVal")>"+"&LvarIncVal=<cfoutput>#LvarIncVal#</cfoutput></cfif><cfif isdefined("Form.PCEcatid")>"+"&PCEcatid=<cfoutput>#Form.PCEcatid#</cfoutput></cfif><cfif isdefined("Form.porEmpresa")>"+"&porEmpresa=<cfoutput>#porEmpresa#</cfoutput></cfif>"+"&filtro=<cfoutput><cfif isdefined("#filtro#")>
				<cfset filtro = "#filtro#">
			</cfif> #filtro#</cfoutput>"+"&PCEcodigo=<cfoutput>#Trim(rsPCE.PCEcodigo)#</cfoutput>"+"&PCElongitud=<cfoutput>#Trim(rsPCE.PCElongitud)#</cfoutput>"+"&PCEdescripcion=<cfoutput>#Trim(rsPCE.PCEdescripcion)#</cfoutput>"+"&PCEempresa=<cfoutput>#PCEempresa#</cfoutput>"+"&PCEoficina=<cfoutput>#PCEoficina#</cfoutput>"+"&PCEvaloresxmayor=<cfoutput>#PCEvaloresxmayor#</cfoutput>"+"&PCEreferenciar=<cfoutput>#PCEreferenciar#</cfoutput>"+"&PCEreferenciarMayor=<cfoutput>#PCEreferenciarMayor#</cfoutput>"+"&PCEactivo=<cfoutput>#PCEactivo#</cfoutput>"+"&PCCEdescripcion=<cfoutput>#PCCEdescripcion#</cfoutput>";<!---<cfoutput>#Int(rsPCE.PCElongitud)#</cfoutput>--->

		--->
		
		<cfoutput>
			params = 	"?btnImprime=true&formato=" + formato + 
						"&F_PCDvalor=#URLencodedFormat(Form.F_PCDvalor)#&F_PCDdescripcion=#URLencodedFormat(Form.F_PCDdescripcion)#&F_PCEcatidref=#URLencodedFormat(Form.F_PCEcatidref)#" +
						"&filtro=#URLencodedFormat(filtro)#&PCEcodigo=#URLencodedFormat(Trim(rsPCE.PCEcodigo))#&PCElongitud=#URLencodedFormat(Trim(rsPCE.PCElongitud))#" +
						"&PCEdescripcion=#URLencodedFormat(Trim(rsPCE.PCEdescripcion))#&PCEempresa=#URLencodedFormat(PCEempresa)#&PCEoficina=#URLencodedFormat(PCEoficina)#" +
						"&PCEvaloresxmayor=#URLencodedFormat(PCEvaloresxmayor)#&PCEreferenciar=#URLencodedFormat(PCEreferenciar)#&PCEreferenciarMayor=#URLencodedFormat(PCEreferenciarMayor)#" +
						"&PCEactivo=#URLencodedFormat(PCEactivo)#&PCCEdescripcion=#URLencodedFormat(PCCEdescripcion)#";
<cfif isdefined("Form.IncVal") >			params = params + "&LvarIncVal=#URLencodedFormat(LvarIncVal)#";</cfif>
<cfif isdefined("Form.PCEcatid")>			params = params + "&PCEcatid=#URLencodedFormat(Form.PCEcatid)#";</cfif>
<cfif isdefined("Form.porEmpresa")>			params = params + "&porEmpresa=#URLencodedFormat(porEmpresa)#";</cfif>

</cfoutput>
		
		popUpWindow("Catalogos-sql.cfm"+params,250,200,650,400);
		
	}
	var popUpWin = 0;
	
	
	
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}



	function verificaEstadoPadre(obj,obj1)
	{
		if (!obj1.checked)
		{
			if (obj.disabled)
				obj.disabled = false;
		}
		else
			obj.disabled = true;
	}
	
	function MostrarOf()
	{			
		var checked1 = document.getElementById('PCEempresa').checked;
		var checked2 = document.getElementById('PCEreferenciar').checked;
		if (checked1)
		{
			document.getElementById('etiquetaof').style.visibility = 'visible';
		}
		else
		{
			document.getElementById('PCEoficina').checked = false;
			document.getElementById('etiquetaof').style.visibility = 'hidden';			
		}
		if (checked1 && checked2)
		{
			document.getElementById('etiquetaref').style.visibility = 'visible';
		}
		else
		{
			document.getElementById('PCEreferenciarMayor').checked = false;
			document.getElementById('etiquetaref').style.visibility = 'hidden';			
		}
	}

	// Funciones para Manejo de Botones
	botonActual = "";

	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}

	//validaciones adicionadas al API de qforms
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	function _Field_isRango(low, high){
		if(this.obj.form.botonSel.value != 'btnLista'){
			var low=_param(arguments[0], 0, "number");
			var high=_param(arguments[1], 9999999, "number");
			var iValue=parseInt(qf(this.value));

			if(isNaN(iValue))
				iValue=0;

			if((low>iValue)||(high<iValue)){
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}
	}
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	<cfif MODO NEQ "ALTA">
	function ingresaUsu(){
		document.location="UsuxCatalogo.cfm?PCEcatid=<cfoutput>#Form.PCEcatid#</cfoutput>";
	}
	</cfif>
	<cfif isdefined("Form.IncVal")>
		function DeshabilitaValoresEnc()
		{
			document.form1.PCEempresa.disabled = true;
			document.form1.PCEoficina.disabled = true;
			document.form1.PCEvaloresxmayor.disabled = true;
			document.form1.PCEreferenciarMayor.disabled = true;
			document.form1.PCEref.disabled = true;
			document.form1.PCEreferenciar.disabled = true;
			document.form1.PCEactivo.disabled = true;
			document.form1.PCCEclaid.disabled = true;
		}
		DeshabilitaValoresEnc();
	</cfif>	
	
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isRango", _Field_isRango);
	_addValidator("isFecha", _Field_isFecha);
	//definicion del color de los campos con errores de validación para cualquier instancia de qforms
	qFormAPI.errorColor = "#FFFFCC";
	//instancias de qforms
	objForm = new qForm("form1");
	//descripciones de objetos de la instancia de qform definida
	objForm.PCEcodigo.description = "Código del Catálogo";
	objForm.PCElongitud.description = "Longitud";
	objForm.PCEdescripcion.description = "Descripción";
	objForm.PCEempresa.description = "Valores Definidos por Empresa";
	objForm.PCEref.description = "Referenciado por otros Catálogos";
	objForm.PCEreferenciar.description = "Debe Referenciar a otros Catálogos";
	objForm.PCEactivo.description = "Catálogo Activo";
	//campos requeridos de la instancia de qform definida
	objForm.PCEcodigo.required = true;
	objForm.PCElongitud.required = true;
	objForm.PCEdescripcion.required = true;
	//validaciones de los objetos de la instancia de qform definida
	objForm.PCEcodigo.validateAlfaNumerico();
	objForm.PCElongitud.validateRango(1,10);
	//objForm.PCEdescripcion.validateAlfaNumerico();
	//validaciones fozadas en el onBlur de los objetos de la instancia de qform definida
	objForm.PCElongitud.validate = true;
	//Define el objecto que obtiene el foco
	objForm.PCEcodigo.obj.focus();
	<cfif MODO eq "CAMBIO">
		//descripciones de los campos requeridos del detalle
		objForm.PCEcatidref.description = "Catálogo Referenciado";
		objForm.PCDvalor.description = "Valor";
		objForm.PCDdescripcion.description = "Descripción";
		//campos requeridos del detalle
		//objForm.PCEcatidref.required = true;
		objForm.PCDvalor.required = true;
		objForm.PCDdescripcion.required = true;
		//objForm.PCDactivo.required = true;
		//validaciones del detalle
		objForm.PCDvalor.validateAlfaNumerico();
		//objForm.PCDdescripcion.validateAlfaNumerico();
		<cfif rsPCE.PCEreferenciar EQ "1">
			objForm.PCEcatidref.required = true;
		</cfif>
		<cfif rsPCEclas.PCCEclaid NEQ "">
			objForm.PCCDclaid.description = "<cfoutput>#rsPCEclas.PCCEdescripcion#</cfoutput>";
			objForm.PCCDclaid.required = true;
		</cfif>
		//definición del objeto que obtendrá el foco de la instancia de qform definida para el MODO CAMBIO
		objForm.PCDvalor.obj.focus();
	<cfelse>
		//definición del objeto que obtendrá el foco de la instancia de qform definida para el MODO ALTA
		objForm.PCEcodigo.obj.focus();
	</cfif>
</script>

