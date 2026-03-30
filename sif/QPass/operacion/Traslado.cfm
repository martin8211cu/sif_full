<cf_templateheader title="SIF - Quick Pass">
	<cf_web_portlet_start titulo="Traslado de Tags">
	<br>
	<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="60%" valign="top">
				<cfif isDefined("Url.QPTid") and not isDefined("form.QPTid")>
				  <cfset form.QPTid = Url.QPTid>
				</cfif>		
				<cfif isdefined("url.QPTidTag") and len(trim(url.QPTidTag))>
					<cfset form.QPTidTag = url.QPTidTag>
				</cfif>					
				
				<cfset navegacion = "">
				
			<cfquery name="rsEncabezado" datasource="#session.dsn#">
				select 
					QPTtrasDocumento, 
					QPTtrasDescripcion, 
					oo.Oficodigo as OficinaO,  
					oo.Odescripcion as OficinaOri,
					od.Odescripcion as OficinaDest,
					od.Oficodigo as OficinaD, 
					BMFecha as Fecha,
                    oo.Ocodigo as OcodigoOri,
                    od.Ocodigo as OcodigoDest
						from QPassTraslado e
							inner join Oficinas oo
							on oo.Ecodigo = e.Ecodigo
							and oo.Ocodigo = e.OcodigoOri
						
							inner join Oficinas od
							on od.Ecodigo = e.Ecodigo
							and od.Ocodigo = e.OcodigoDest
						where e.QPTid = #form.QPTid#
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
			<form action="TrasladoQPass_SQL.cfm" name="form2" method="post">
				<input type="hidden" name="OcodigoOri" value="#rsEncabezado.OcodigoOri#" >
				<input type="hidden" name="OcodigoDest" value="#rsEncabezado.OcodigoDest#" >
				<input type="hidden" name="QPTid" value="#form.QPTid#" >


				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td><strong>Documento:&nbsp;</strong>
						#rsEncabezado.QPTtrasDocumento#</td>
					</tr>
					<tr>
						<td><strong>Sucursal Origen:&nbsp;</strong>
						#rsEncabezado.OficinaOri#</td>
					</tr>
					<tr>
						<td><strong>Sucursal Destino:&nbsp;</strong>
						#rsEncabezado.OficinaDest#</td>
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
			
			<fieldset><legend><strong>Sucursal Origen</strong></legend>
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
					irA="Traslado.cfm?QPTid=#QPTid#"
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
					<cfinclude template="Traslado_form.cfm"> 
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
			document.form2.action='Traslado.cfm';
			document.form2.submit;
		}
</script>		

