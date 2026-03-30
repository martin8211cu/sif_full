<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_Confirma_que_desea_Aplicar_esta_Relacion" default="¿Confirma que desea Aplicar esta Relación?"	 returnvariable="MSG_AplicarRelacion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Identificacion" default="Identificación"	 returnvariable="LB_Identificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!---Boton limpiar ---->
<cfinvoke key="BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!---Boton filtrar ---->
<cfinvoke key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!---Boton de aplicar ---->
<cfinvoke key="BTN_Aplicar" default="Aplicar" returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<!---Boton de Comisiones ---->
<cfinvoke key="BTN_Comisiones" default="Comisiones"	 returnvariable="BTN_Comisiones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empleado" default="Empleado"	 xmlfile="/rh/generales.xml" returnvariable="LB_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Salario_Bruto" default="S. Bruto"	 returnvariable="LB_Salario_Bruto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Incidencias" default="Incidencias"	 returnvariable="LB_Incidencias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Salario_Liquido" default="S. Líquido"	 returnvariable="LB_Salario_Liquido" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined("Url.RCNid") and not isdefined("Form.RCNid")>
	<cfparam name="Form.RCNid" default="#Url.RCNid#">
</cfif>
<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
	<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
</cfif>
<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
	<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
</cfif>		
<cfif isdefined("Url.fSEcalculado") and not isdefined("form.fSEcalculado")>
	<cfparam name="form.fSEcalculado" default="#Url.fSEcalculado#">
</cfif>		
<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
	<cfparam name="Form.filtrado" default="#Url.filtrado#">
</cfif>	
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>		

<cfset filtro = "">
<cfset navegacion = "">

<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
<cfif isdefined("Form.DEid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & form.DEid>
</cfif>
<cfif isdefined("Form.RCNid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RCNid=" & form.RCNid>				
</cfif>
 
<cf_dbfunction name="concat" args="b.DEapellido1,' ',b.DEapellido2,' ',b.DEnombre" returnvariable="empleadofiltro">

<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0> 
	<cfset filtro = filtro & " and upper(#preservesinglequotes  (empleadofiltro)#) like '%" & #UCase(Form.nombreFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
</cfif>

<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & #UCase(Form.DEidentificacionFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
</cfif>
<cfif isdefined("form.fSEcalculado") >
	<cfset filtro = filtro & " and SEcalculado  = #form.fSEcalculado# ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSEcalculado=" & form.fSEcalculado>
</cfif>
<cfif isdefined("Form.sel") and form.sel NEQ 1>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>
</cfif>

		
<style type="text/css">
.chk {  
 background: buttonface; 
 padding: 1px;
 color: buttontext;
}
</style>

<cfquery name="rsCantModificados" datasource="#Session.DSN#">
	select count(1) as cantidad
    from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and SEcalculado <> 1
</cfquery>

<cfset pintarReporte = true>

<cfset Request.Regresar = "PTU.cfm">
<cfinclude template="/rh/portlets/pRelacionCalculoPTU.cfm">



<cfoutput>
<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
		<td width="90%">
			<form name="formFiltroListaEmpl" method="post" action="PTU.cfm">
            	<input type="hidden" name="RHPTUEid" value="<cfoutput>#Form.RHPTUEid#</cfoutput>">
                <input type="hidden" name="tab" value="5">
				<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
				<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">
				<input type="hidden" name="RCNid" value="<cfoutput>#Form.RCNid#</cfoutput>">
								

				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" align="center">
					<tr> 
						<td width="25%" height="17" class="fileLabel">#LB_Identificacion#</td>
						<td width="50%" class="fileLabel"><cf_translate key="LB_Nombre_del_empleado" XmlFile="/rh/generales.xml">Nombre del empleado</cf_translate></td>
						<td width="20%" class="fileLabel">&nbsp;</td>
						<td width="5%" rowspan="2" class="fileLabel" nowrap>
							<input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#">
							<input name="btnLimpiar" type="button" id="btnLimpiar" value="#BTN_Limpiar#" onclick="javascript:limpiar();">
						</td>
					</tr>
					<tr> 
						<td>
							<input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>">
						</td>
						<td>
							<input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>">
						</td>
					</tr>
				</table>
			</form>
		</td>
	</tr>

  <tr>
    <td width="90%">

        <cfquery name="rsRCNomina" datasource="#session.DSN#">
            select count(1) as cantidad
            from RHPTUE a
            	inner join RCalculoNomina b
            	   on b.RHPTUEid = a.RHPTUEid
            where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
              and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
              and b.RCestado >= 3
        </cfquery>
        
        <!--- Verifica que no existan nóminas pendientes de aplicar: by LZ --->
        <!--- En el momento que ya no existan nóminas pendientes de aplicar aparecerá el botón de aplicar --->
        <cfquery name="rsVerifica" datasource="#session.DSN#">    
            select  
               a.CPid, a.CPdesde, a.CPhasta, a.CPtipo, a.CPfenvio,
               c.CPid as CPidPTU, c.CPdesde as CPdesdePTU, c.CPhasta as CPhastaPTU, c.CPtipo as CPtipoPTU, c.CPfenvio as CPfenvioPTU
            from CalendarioPagos a, CalendarioPagos c
            Where a.CPid not in (Select RCNid 
                            from HRCalculoNomina b
                            Where a.Tcodigo=b.Tcodigo
                            and a.Ecodigo=b.Ecodigo)
                and a.Tcodigo = c.Tcodigo
                and a.Ecodigo = c.Ecodigo
                
                and c.CPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                and c.CPhasta  > a.CPdesde
                
                and a.Ecodigo = #session.Ecodigo#
                and a.CPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                
                and c.CPtipo = 4
            order by 1
        </cfquery>
        
        <cfset LvarMensaje = ''>
        <cfif rsVerifica.recordcount gt 0>
            <cfquery name="rsverificaQofQ" dbtype="query">
                select 
                    min(CPdesde) as MINCPdesde,
                    max(CPhasta) as MaxCPHasta
                from rsVerifica
            </cfquery>
	        <cfset LvarMensaje = 'El resultado de la Relación de Cálculo (desde #lsdateformat(rsVerifica.CPdesdePTU, 'dd/mm/yyyy')# hasta #lsdateformat(rsVerifica.CPhastaPTU,'dd/mm/yyyy')#) no podrá ser aplicada inmediatamente, hasta que se apliquen #rsVerifica.recordcount# nominas anteriores que van desde #lsdateformat(rsverificaQofQ.MINCPdesde,'dd/mm/yyyy')# hasta #lsdateformat(rsverificaQofQ.MaxCPHasta,'dd/mm/yyyy')#.'>
        </cfif>
    	
	    <cfset botones = "">
		<cfif rsCantModificados.cantidad gt 0>
			<cfset botones = "">
		<cfelse>
        	<cfif rsRCNomina.cantidad  EQ 0 and rsVerifica.recordcount eq 0>
	            <cfset botones = "Aplicar">
            <!--- <cfelse>
            	<cfset botones = "Revisar"> El aplicar aparece solo cuando ya no existan nóminas pendientes de aplicar --->
            </cfif>
		</cfif>
		
		
		<cfset imgok = "">
		<cfset imgrecalcular = "<img border=''0'' src=''/cfmx/rh/imagenes/Cferror.gif'' onClick=''javascript:return funcOpen();''>">

		<!--- para mantener el check de calculado en el filtro --->	
		<cfset calculado = "" >
		<cfif isdefined("form.fSEcalculado")>
			<cfset calculado = ", 0 as fSEcalculado" >
		</cfif>

		<!--- datos --->	
		<cf_dbfunction name="concat" args="DEapellido1,' ',DEapellido2,' ',DEnombre" returnvariable="nombre">
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaEmpl">
			<cfinvokeargument name="tabla" value="SalarioEmpleado a, DatosEmpleado b"/>
			<cfinvokeargument name="columnas" value="'#Form.RCNid#' as CPid, '#Form.RCTcodigo#' as Tcodigo, a.RCNid, b.DEid, b.DEidentificacion, 
													#preservesinglequotes(nombre)# as nombreEmpl, 
													a.SEsalariobruto, a.SEincidencias, a.SEliquido, 
													case SEcalculado when 1 then '#imgok#' else '#imgrecalcular#' end as estado, 
													1 as o, '#form.RHPTUEid#' as RHPTUEid, 5 as tab, 1 as sel #calculado# "/>
			<cfinvokeargument name="desplegar" value="DEidentificacion, nombreEmpl, SEsalariobruto, SEincidencias, SEliquido, estado"/>
			<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Empleado#, #LB_Salario_bruto#,#LB_Incidencias#,#LB_Salario_Liquido#, "/>
			<cfinvokeargument name="formatos" value="S,S,M,M,M,S"/>
			<cfinvokeargument name="formName" value="listaEmpleados"/>	
			<cfinvokeargument name="filtro" value="a.RCNid = #Form.RCNid# and b.DEid = a.DEid  #filtro# order by SEcalculado,DEidentificacion, DEapellido1, DEapellido2, DEnombre"/>
			<cfinvokeargument name="align" value="left,left,right,right,right,right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="irA" value="PTU.cfm"/><!--- PTU-ResultadoCalculoTab5.cfm --->
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="botones" value="#botones#"/>
		</cfinvoke>
	</td>
    
    <cfif rsVerifica.recordcount gt 0>
    	<tr>
        	<td align="center">
               <strong>**#LvarMensaje#**</strong>
            </td>
        </tr>
    </cfif>
    <cfif rsRCNomina.cantidad  GT 0>
    	<tr>
        	<td align="center">
               <strong>**Esta relación ya fue aplicada y está pendiente de verificación en la opción: Recepción de Pagos, Verificación de Nómina**</strong>
            </td>
        </tr>
    </cfif>
  </tr>
</table>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	var _RCNid = document.formFiltroListaEmpl.RCNid.value;
	var nuevo=0;
	function funcOpen(id) {
			var width = 500;
			var height = 150
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('ResultadoCalculoMensajes.cfm?RCNid='+_RCNid,'Justificacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			document.listaEmpleados.nosubmit = true;
			return false;	
		}
		

	function closePopUp(){
		if(nuevo) {
			if(!nuevo.closed) nuevo.close();
			nuevo=null;
		}
	}
	<cfoutput>
		function funcDeducciones(){
			document.listaEmpleados.action = '/cfmx/rh/admin/catalogos/calendarioPagos_relacion.cfm';
			document.listaEmpleados.TCODIGO.value = '<cfoutput>#form.RCTcodigo#</cfoutput>';
			document.listaEmpleados.CPID.value = '<cfoutput>#form.RCNid#</cfoutput>';
			document.listaEmpleados.submit();
		}

	
		<cfif rsCantModificados.cantidad lte 0>
			function funcAplicar(){
				var result = false;
				if (confirm("#MSG_AplicarRelacion#")) {
					document.location = "PTU-ResultadoCalculoTab5-listaSql.cfm?Accion=Aplicar&RCNid=#Form.RCNid#&RHPTUEid=#form.RHPTUEid#";
				}
				return result;
			}
		</cfif>
	</cfoutput>
	
	function funcRevisar(){
		document.location = "PTU-ResultadoCalculoTab5-listaSql.cfm?Accion=Revisar&RCNid=#Form.RCNid#&RHPTUEid=#form.RHPTUEid#";
		return true;
		}
	
	function limpiar(){
		document.formFiltroListaEmpl.DEidentificacionFiltro.value = "";
		document.formFiltroListaEmpl.nombreFiltro.value = "";
		document.formFiltroListaEmpl.fSEcalculado.checked = false;
	}
</script>