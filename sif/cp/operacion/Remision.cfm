<!--- 
	Requerimiento  para ingresar Remisiones en  CxP Septiembre 2014 IRR APH
 --->

<cfif not isdefined("form.SNcodigo") and isdefined ("url.SNcodigo") and len(trim(url.SNcodigo))>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif not isdefined("form.IDdocumento") and isdefined ("url.IDdocumento") and len(trim(url.IDdocumento))>
	<cfset form.IDdocumento = url.IDdocumento>
</cfif>
<cfif not isdefined("form.Mcodigo") and isdefined ("url.Mcodigo") and len(trim(url.Mcodigo))>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>


	<cfif isdefined ("form.SNcodigo") and len(trim(form.SNcodigo))>
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
	    		<tr>
     				 <td>
						<!---  Filtro  --->

						<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>						
						<cfoutput>
							<form style="margin: 0" action="Remision.cfm" name="fsolicitud" id="fsolicitud" method="post">
								<input type="hidden" value="#form.IDdocumento#" name="IDdocumento">
								<input type="hidden" value="#form.SNcodigo#" name="SNcodigo">
							<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
							  <tr> 
								<td class="fileLabel" nowrap width="8%" align="right"><label for="Documento">Documento:</label></td>
								
								<td nowrap width="25%"><input type="text" name="fDocumento" size="20" maxlength="40" value="<cfif isdefined('form.fDocumento')>#form.fDocumento#</cfif>" style="text-transform: uppercase;" tabindex="1">
								</td>
                                <td class="fileLabel" align="right" nowrap width="10%">Proveedor:</td>
								<td nowrap width="10%">
									<cfset valSNcodF = ''>
									<cfif isdefined('form.SNcodigoF') and Len(Trim(form.SNcodigoF))>
									  <cfset valSNcodF = form.SNcodigoF>
									</cfif>
									<cf_sifsociosnegocios2 form="fsolicitud" idquery="#valSNcodF#" sntiposocio="P" sncodigo="SNcodigoF" snnumero="SNnumeroF" frame="frame1" tabindex="1">
								</td>
								<td class="fileLabel" align="right" nowrap>Fecha:</td>
								<td nowrap>
									<cfif isdefined('form.fEOfecha') and Len(Trim(form.fEOfecha))>
										<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEOfecha" value="#form.fEOfecha#" tabindex="1">
									<cfelse>
										<cf_sifcalendario conexion="#session.DSN#" form="fsolicitud" name="fEOfecha" value="" tabindex="1">
									</cfif>	
								</td>
								<td width="27%"  align="center" valign="middle"><input type="submit" name="btnFiltro" class="btnFiltrar" value="Filtrar"></td>  
							  </tr>
							  
							</form>
						</cfoutput>
						<!---  /Filtro  --->

						<cfset navegacion = "">
						
						<cfif isdefined("Form.SNcodigo") and len(trim(Form.SNcodigo)) >
							<cfset navegacion = navegacion & "&SNcodigo=#form.SNcodigo#">
						</cfif>
						<cfif isdefined("Form.IDdocumento") and len(trim(Form.IDdocumento)) >
							<cfset navegacion = navegacion & "&IDdocumento=#form.IDdocumento#">
						</cfif>	
                        <cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo)) >
							<cfset navegacion = navegacion & "&Mcodigo=#form.Mcodigo#">
						</cfif>	
                       
                        
                        <cfquery name="rsRemision" datasource="#session.dsn#">
                        	select idRemision,Numero_Documento, SNnombre,Fecha_compra, Miso4217 as Moneda,Total, 
                            case when Icodigo = 'IVA0' then  'Compras 0%' when Icodigo = 'IVA16' then 'Compras 16%' end Descripcion,
                            #form.IDdocumento# as IDdocumento
                            from RemisionesE  rem
                            inner join Snegocios sn on rem.Ecodigo=sn.Ecodigo and rem.Proveedor=sn.SNcodigo
                            inner join Monedas m on rem.Ecodigo=m.Ecodigo and rem.Moneda=m.Mcodigo  
                            where rem.Ecodigo = #session.Ecodigo#
                            and proveedor = #Form.SNcodigo#
                            and rem.Estatus = 10 
                            and ( (select count(1) from RemisionesD g 
										where g.idRemision = rem.idRemision)
										>
							  			(select count(1)  
										from RemisionesD g 
											inner join DDocumentosCxP aa 
											on aa.idDetRemision = g.idDetRem 
										where g.idRemision = rem.idRemision ))
                        </cfquery>
						
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query" 				value="#rsRemision#"/>
							<cfinvokeargument name="desplegar" 			value="Numero_Documento,  SNnombre,Descripcion, Fecha_compra, Moneda, Total"/> 
							<cfinvokeargument name="etiquetas" 			value="Documento,Proveedor,Descripcion, Fecha,  Moneda, Total"/> 
							<cfinvokeargument name="formatos" 			value="V,V,V,D,V,M"/> 
							<cfinvokeargument name="align" 				value="left,left,center,left,left,right"/> 
							<cfinvokeargument name="maxrows" 			value="50"/>
							<cfinvokeargument name="ajustar" 			value="N"/>
							<cfinvokeargument name="irA" 				value="Remision.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
							<cfinvokeargument name="keys" 				value="idRemision,IDdocumento"/>
							<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
							<cfinvokeargument name="inactivecol" 		value="marca"/>
							<cfinvokeargument name="usaAjax" 			value="true"/>
							<cfinvokeargument name="conexion" 			value="#session.dsn#"/>
						</cfinvoke>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
 				<tr><td>&nbsp;</td></tr>
			</table>
	</cfif>


<script language="javascript1.2" type="text/javascript">
	function funcAplicar(){
		var continuar = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				continuar = document.lista.chk.checked;
			}
			else {
				for (var k = 0; k < document.lista.chk.length; k++) {
					if (document.lista.chk[k].checked) {
						continuar = true;
						break;
					}
				}
			}
			if (!continuar) { alert('Debe seleccionar una Remision'); }
		}
		else {
			alert('No existen Remisiones')
		}

		if ( continuar ){
			document.lista.action = 'Remision-sql.cfm';
			document.lista.submit();
		}	

		return continuar;
	}
</script>

<!--- Lista del Detalle (Con el Encabezado) --->
<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
<style type="text/css">
<!--
.style4 {font-size: 12px}
-->
</style>
<!---checar algo--->
<!--- Consulta del encabezado de la Remision ---> 
	<cfquery name="rsRemision" datasource="#Session.DSN#">
		select  idRemision, Numero_Documento,SNcodigo, SNnombre, Fecha_Compra,Moneda,Proveedor,Tipo_Cambio,Fecha_Compra
		from Remisiones rem 
        	inner join SNegocios sn on sn.Ecodigo=rem.Ecodigo and sn.SNcodigo=rem.Proveedor        	    
		where rem.Ecodigo =  #Session.Ecodigo# 
		  and rem.Numero_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Numero_Documento#">
	</cfquery>

	
	<cfif isdefined('rsRemision') and rsRemision.recordCount GT 0 and rsRemision.Moneda NEQ ''>
		<cfquery name="rsMonedaSel" datasource="#Session.DSN#">
			Select Mcodigo,Mnombre,Miso4217
			from Monedas
			where Ecodigo= #Session.Ecodigo# 
				and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRemision.Moneda#">
		</cfquery>
	</cfif>

	<!--- Nombre del Socio --->
	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		<!---select SNcodigo, SNidentificacion, <cf_dbfunction name="sPart" args="SNnombre, 1, 20"> as SNnombre  from SNegocios --->
        select SNcodigo, SNidentificacion, SNnombre  from SNegocios 
		where Ecodigo =  #Session.Ecodigo# 
		  	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsRemision.Proveedor#">
	</cfquery>
	

<!---Javascript Incial--->
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>

<cfoutput>
<table align="center" width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td nowrap class="subTitulo"><font size="2">Encabezado  de Remisiones</font></td>
  </tr>
</table>
<table align="center" width="70%"  border="0" cellspacing="2" cellpadding="0" summary="Formulario del Encabezado de Remisiones)">
  <tr>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
    <td nowrap>&nbsp;</td>
  </tr>
  <!---Línea 1--->
	<tr>
    <td nowrap align="left"><strong>Documento:&nbsp;</strong></td>
    <td nowrap align="left">
			<!---Número de Documento: Este campo se llena con un cálculo en el SQL --->
			<input type="text" name="Documento" size="18" tabindex="1"
				style="border: 0px none; background-color: ##FFFFFF;" maxlength="10" readonly=""  align="right"	
				value="<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#rsRemision.Numero_Documento#<cfelse>N/D</cfif>"></td>
    <td nowrap align="left"><strong>Provedor:&nbsp;</strong></td>
    <td nowrap align="left">
			<!---Provedor--->
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
				#rsNombreSocio.SNnombre# 
				<input type="hidden" name="SNcodigo" value="#rsRemision.SNcodigo#">
			<cfelseif isdefined("form.SNcodigo") and len(trim(form.SNCodigo))>			
				<cf_sifsociosnegocios2 sntiposocio="P" tabindex="1" idquery="#form.SNcodigo#">
			</cfif>
		</td>
  </tr>
	<!---Línea 2--->
  <tr>
    <td nowrap align="left"><strong>Fecha:&nbsp;</strong></td>
    <td nowrap align="left">
			<!---Fecha--->
			<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
				<input type="hidden" name="fecha" id="fecha" value="<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>#LSDateFormat(rsRemision.Fecha_Compra,'dd/mm/yyyy')#</cfif>">
				#LSDateFormat(rsRemision.Fecha_Compra,'dd/mm/yyyy')#
			</cfif> 
		</td>
    <td nowrap align="left"><strong>Moneda:&nbsp;</strong></td>
    <td nowrap align="left">
		<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
		 <input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsRemision.Moneda#">
		 <input type="hidden" name="TC" id="TC" value="#rsRemision.Tipo_Cambio#">
			#rsMonedaSel.Mnombre#
		</cfif>  
 	</td>    
  </tr>

  <tr>
  </tr> 
  <tr><td nowrap colspan="6">&nbsp;</td></tr>
</table>
</cfoutput>
<!--- checar aqui  --->
<!--- Fin Encabezado --->
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="subTitulo"><font size="2">Lista de Detalles</font>
            <cfsavecontent variable="helpimg">
                <img src="../../imagenes/Help01_T.gif" width="25" height="23" border="0" style="position: relative; top: 5px;"/>
            </cfsavecontent>
            <cf_notas name="notas" titulo="Lista de Detalles" link="#helpimg#" pageIndex="0" msg = "Las columnas deshabilitadas indican que ya se encuentran asignadas a alguna Factura." animar="true">
        </td>
	</tr>
</table>
<!---Lista de Items--->
<cfif isdefined("form.Numero_Documento") and len(trim(form.Numero_Documento))>
    <cfquery name="rsListaItems" datasource="#session.dsn#">
        select  remd.idDetRem,ID_linea, Numero_Documento,SNcodigo, SNnombre, Fecha_Compra,Moneda,Proveedor, Tipo_Cambio, Fecha_Compra, Total_lin, 
        Cod_Impuesto, case when Cod_Impuesto = 'IVAO' then  'CMP0' when Cod_Impuesto = 'IVA16' then 'CMP16' end Cod_Item, 
        case when Cod_Impuesto = 'IVA0' then  'Compras 0%' when Cod_Impuesto = 'IVA16' then 'Compras 16%' end Descripcion,
        #form.IDdocumento# as IDdocumento,
        case 
               	when (select count(1)
                  from DDocumentosCxP aa
                  inner join RemisionesD bb
                  on bb.idDetRem = aa.idDetRemision
                  where aa.idDetRemision = remd.idDetRem) = 0 then
                	0
                else
                	#form.IDdocumento# 
            end as chico
            from RemisionesD remd
                inner join RemisionesE rem on  remd.Ecodigo=rem.Ecodigo and rem.ID_DocumentoC=remd.ID_DocumentoC
                inner join SNegocios sn on sn.Ecodigo=rem.Ecodigo and sn.SNcodigo=rem.Proveedor      
        where rem.Ecodigo =  #Session.Ecodigo# 
             and rem.Numero_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Numero_Documento#">
    </cfquery>
</cfif>
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
        	<cfset navegacion = "">
			<cfif isdefined("form.idDocumento") and len(trim(form.idDocumento)) >
				<cfset navegacion = navegacion & "&idDocumento=#form.idDocumento#">
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
				<cfinvokeargument name="query" value="#rsListaItems#">
				<cfinvokeargument name="desplegar" value="ID_linea,Numero_Documento,SNnombre,Descripcion,Fecha_compra, Total_lin">
				<cfinvokeargument name="etiquetas" value="L&iacute;nea,Documento,Proveedor,Descripcion,Fecha,Total">
				<cfinvokeargument name="formatos" value="V,V,V,V,D,V">
				<cfinvokeargument name="align" value="left,left,left,left,left,right">
				<cfinvokeargument name="ajustar" value="S">
				<cfif isdefined ("rsListaItems") and rsListaItems.recordcount GT 0>
					<cfinvokeargument name="botones" value="Agregar"/>
				</cfif>
                <cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="irA" value="Remision-SQL.cfm">
				<cfinvokeargument name="formName" value="form3">
				<cfinvokeargument name="keys" value="idDocumento,IdDetRem">
				<cfinvokeargument name="funcion" value="ProcesarLinea">
				<cfinvokeargument name="fparams" value="IdDetRem">
				<cfinvokeargument name="checkboxes" value="S"/>
                <cfinvokeargument name="checkall" value="S"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="usaAjax" value="true"/>
				<cfinvokeargument name="conexion" value="#session.dsn#"/>				
				<cfinvokeargument name="maxrows" value="0"/>
                 <cfinvokeargument name="inactivecol"  value="chico"/>
			</cfinvoke>
		</td>
	</tr>
</table>

<script language='javascript' type='text/JavaScript' >
<!--//
	function ProcesarLinea(Linea){
		return false;
	}
//-->
</script>

<hr width="99%" align="center">
</cfif>
