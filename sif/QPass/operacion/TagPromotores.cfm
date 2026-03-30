<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start titulo="Asigna Tags Promotor">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.QPEAPid") and not isDefined("form.QPEAPid")>
				  <cfset form.QPEAPid = Url.QPEAPid>
				</cfif>		
				<cfif isdefined("url.QPTidTag") and len(trim(url.QPTidTag))>
					<cfset form.QPTidTag = url.QPTidTag>
				</cfif>					
				
				<cfset navegacion = "">
                <cf_dbfunction name='OP_CONCAT' returnvariable="_Cat">
                <cfquery name="rsEncabezado" datasource="#session.dsn#">
                    select 
                        a.QPEAPDocumento, 
                        a.QPEAPDescripcion, 
                        c.Oficodigo as OficinaO,  
                        c.Odescripcion as OficinaOri,
                        c.Ocodigo as OcodigoOri,
                        b.QPPid, 		<!--- Promotor Destino id     --->
                        b.QPPnombre,	<!--- Promotor Destino nombre --->
                        b.QPPcodigo,	<!--- Promotor Destino codigo --->
                        d.Usulogin,
                        e.Pnombre #_Cat# ' ' #_Cat# e.Papellido1 #_Cat# ' '  #_Cat# e.Papellido2 as Usuario,
                        a.BMFecha as Fecha
    
                    from QPEAsignaPromotor  a
                        inner join QPPromotor b
                            on b.QPPid = a.QPPid
                        inner join Oficinas c
                            on c.Ecodigo  = b.Ecodigo
                            and c.Ocodigo = b.Ocodigo
                        inner join Usuario d
                            on d.Usucodigo = a.Usucodigo
                        inner join DatosPersonales e
                            on e.datos_personales = d.datos_personales
    
                    where a.QPEAPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPEAPid#">
                    and b.QPPestado = '1'
                    and a.Ecodigo = #session.Ecodigo#
                </cfquery>
                    
                <cfquery name="rsLista" datasource="#session.dsn#">
                    select 
                        a.QPTidTag, 
                        a.QPTPAN, 
                        a.QPTNumSerie,
                        a.BMFecha,
                        b.QPLcodigo 
                    from QPassTag a
                        inner join QPassLote b
	                        on a.QPidLote = b.QPidLote
                        inner join QPassEstado c
			            	on c.QPidEstado = a.QPidEstado
                    where a.Ecodigo =#session.Ecodigo#
                      and a.Ocodigo = #rsEncabezado.OcodigoOri#
                      and a.QPTEstadoActivacion in (1,2)
                      and c.QPEdisponibleVenta = 1
                        <cfif isdefined('form.Filtrotag')and len(trim(form.Filtrotag)) >
                            and upper(a.QPTPAN) like upper('%#form.Filtrotag#%')
                        </cfif>	
                        <cfif isdefined('form.Filtrolote')and len(trim(form.Filtrolote)) >
                            and upper(b.QPLcodigo) like upper('%#form.Filtrolote#%')
                        </cfif>	
                </cfquery>	
				
			<cfoutput>
			<form action="TagPromotores_SQL.cfm" name="form2" method="post">
				<input type="hidden" name="OcodigoOri" value="#rsEncabezado.OcodigoOri#" >
				<input type="hidden" name="QPPid" value="#rsEncabezado.QPPid#" >
				<input type="hidden" name="QPEAPid" value="#form.QPEAPid#" >


				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td><strong>Documento:&nbsp;</strong>
						#rsEncabezado.QPEAPDocumento#</td>
					</tr>
                    <tr>
						<td><strong>Descripci&oacute;n:&nbsp;</strong>
						#rsEncabezado.QPEAPDescripcion#</td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong>Usuario que envia:&nbsp;</strong>
						#rsEncabezado.Usulogin# - #rsEncabezado.Usuario#</td>
					</tr>
					<tr>
						<td nowrap="nowrap"><strong>Promotor Destino:&nbsp;</strong>
						#rsEncabezado.QPPcodigo# - #rsEncabezado.QPPnombre#</td>
					</tr>
					<tr>
					</tr>
					<tr><td colspan="4"><hr></td></tr>
					<tr>
						<td><strong>TAG</strong></td>
						<td><strong>Lote</strong></td>
					</tr>
					<tr>
						<td><input type="text" name="Filtrotag"  tabindex="1" value="<cfif isdefined('form.Filtrotag')>#form.Filtrotag#</cfif>"></td>
						<td><input type="text" name="Filtrolote" tabindex="1" value="<cfif isdefined('form.Filtrolote')>#form.Filtrolote#</cfif>"></td>
						<td><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="2" onclick="funcFiltrar();" /></td>
					</tr>
				</table> 
					<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
				<label for="chkTodos">Seleccionar Todos</label>
			</cfoutput>
			
			<fieldset><legend><strong>Usuario que envia</strong></legend>
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					showLink = "no"
					returnvariable="rsLista"
					query="#rsLista#"
					columnas="QPTPAN, QPLcodigo,BMFecha"
					desplegar="QPTPAN, QPLcodigo,BMFecha"
					etiquetas="TAG, Lote,Fecha de Ingreso"
					formatos="S,S,D"
					align="left,left,left"
					ajustar="S"
					irA="Promotores.cfm?QPEAPid=#QPEAPid#"
					keys="QPTidTag"
					maxrows="50"
					pageindex="3"
					navegacion="#navegacion#" 				 
					showEmptyListMsg= "true"
					checkboxes= "S"
					formname= "form2"
					incluyeForm ="false"
					usaAJAX = "no"
					Botones ="Seleccionar"
					/>
				</form>	
					</td>
					<td width="5%">&nbsp;</td>
					<td width="55%" valign="top">
						<cfinclude template="TagPromotores_form.cfm"> 
					</td>			
				</tr>
			</table>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>
	
<script language="javascript" type="text/javascript">
		function funcSeleccionar(){
		var aplica = false;
			if (document.form2.chk.length) {
					for (var i=0; i<document.form2.chk.length; i++) {
						if (document.form2.chk[i].checked) { 
							aplica = true;
							break;
					}
				}
			} else {
				aplica = document.form2.chk.checked;
			}
			if(!aplica)
				alert('Debe seleccionar al menos un TAG');
			return aplica;
		}

		function Marcar(c) {
			if (c.checked) {
				for (counter = 0; counter < document.form2.chk.length; counter++)
				{
					if ((!document.form2.chk[counter].checked) && (!document.form2.chk[counter].disabled))
						{  document.form2.chk[counter].checked = true;}
				}
				if ((counter==0)  && (!document.form2.chk.disabled)) {
					document.form2.chk.checked = true;
				}
			}
			else {
				for (var counter = 0; counter < document.form2.chk.length; counter++)

				{
					if ((document.form2.chk[counter].checked) && (!document.form2.chk[counter].disabled))
						{  document.form2.chk[counter].checked = false;}
				};
				if ((counter==0) && (!document.form2.chk.disabled)) {
					document.form2.chk.checked = false;
				}
			};
		}
		
		function funcFiltrar(){
			document.form2.action='TagPromotores.cfm';
			document.form2.submit;
		}
</script>		

