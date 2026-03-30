<style type="text/css">
<!--
.style49 {color: #993300}
.style51 {color: #993300; font-size: 18px; }
-->
</style>

<cfif IsDefined("form.AMid") and Len(form.AMid)>
     <cfinclude template="ISBagenteEmail-form.cfm">
<cfelse>
<form name="form1" method="post" action="#CurrentPage#"  style="margin: 0;">
	<cfoutput>
			<input type="hidden" name="AGid" value="<cfif isdefined("form.AGid") and Len(Trim(form.AGid))>#form.AGid#<cfelseif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />	
			<cfinclude template="agente-hiddens.cfm">
	
		<!--- Datos de la cuenta --->
		<cfquery name="rscuenta" datasource="#session.DSN#">
			Select cue.CTid,cue.CUECUE, cue.CTtipoUso, cue.Habilitado 
			from ISBcuenta cue
				inner join ISBpersona per
				on cue.Pquien = per.Pquien
				inner join ISBagente ag
				on ag.Pquien = per.Pquien
			Where ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
		
			<!--- Datos de los productos que el Agente puede comercializar --->
		<cfquery name="rsproductos" datasource="#session.DSN#">
			Select paq.PQcodigo,paq.PQdescripcion,paq.Habilitado
			from ISBpaquete paq
				inner join ISBagenteOferta ofer
				on paq.PQcodigo = ofer.PQcodigo
			Where ofer.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
	
			<!--- Datos de la Oferta del Agente --->
		<cfquery name="rscobertura" datasource="#session.DSN#">
			Select 			
				case when b.DPnivel > 2 then
					(
					select y.LCnombre
					from LocalidadCubo x
						inner join Localidad y
							on y.LCid = x.LCidPadre 
					where x.LCidHijo = b.LCid
					and x.LCnivel = 2
					) || ' / ' 
					else ' '
					end ||
					 case when b.DPnivel > 1 then ( 
					select y.LCnombre from LocalidadCubo x 
						inner join Localidad y 
						on y.LCid = x.LCidPadre 
					where x.LCidHijo = b.LCid 
					and x.LCnivel = 1
					 ) || ' / ' 
					 else ' ' end || b.LCnombre as LCnombre
									
			From ISBagenteCobertura a
				inner join Localidad b
				on a.LCid = b.LCid
				and a.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
		
		
			<!--- Datos del Usuario de Acceso al Sistema --->
		<cfquery name="rsUsuarioSACI" datasource="asp">
			Select Usulogin,Uestado from UsuarioReferencia r
    			inner join Usuario u
    			on r.Usucodigo = u.Usucodigo
				and r.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AGid#" null="#Len(form.AGid) is 0#">
				and r.STabla = 'ISBagente'
		</cfquery>
		
		
		<!--- Bloqueos del Usuario--->
		<cfquery name="bloqueos" datasource="asp">
		Select u.Usucodigo, bloqueo, fecha, razon, case when desbloqueado = 1 then 'Si' else 'No' end as desbloq
 			from UsuarioReferencia r
    		inner join Usuario u
        		on r.Usucodigo = u.Usucodigo
        		and r.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AGid#" null="#Len(form.AGid) is 0#">
        		and r.STabla = 'ISBagente'
    		inner join aspmonitor..UsuarioBloqueo b
        		on u.Usucodigo = b.Usucodigo
			order by bloqueo desc
		</cfquery>
		
		<!--- Datos del Agente--->
		<cfquery name="rsagente" datasource="#session.DSN#">
		Select  AGid,ag.Habilitado,AAinterno
 			from ISBagente ag
    		inner join ISBpersona per
        		on ag.Pquien = per.Pquien
    	Where ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">	
		</cfquery>
		
		<!--- Datos del Contacto--->
		<cfquery name="rscontacto" datasource="#session.DSN#">
		Select co.Pid,co.Pnombre,co.Papellido,co.Papellido2,RJtipo
 			from ISBagente ag
    			inner join ISBpersona p
        			on ag.Pquien = p.Pquien
    			inner join ISBpersonaRepresentante r
        				on p.Pquien = r.Pquien
				inner join ISBpersona co
 					on r.Pcontacto = co.Pquien
    			inner join ISBlocalizacion lo
        			on lo.RefId = r.Rid
        			and Ltipo = 'R'         
 			Where ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
		
		<!---  Historico de Notificaciones para el Agente--->
		<cfquery name="rsEmail" datasource="#session.DSN#">
			Select AGid,AMEsubject, AMEfrom, AMEto, AMEinicio
 				from ISBagenteEmail agm
 			Where agm.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
		
		<!---  Logines de la cuenta del Agente--->
		<cfquery name="rslogines" datasource="#session.DSN#">
			Select lo.LGnumero, lo.LGlogin, lo.Habilitado, LGbloqueado
 				from ISBpersona p
				inner join ISBagente ag
					on p.Pquien = ag.Pquien
				inner join ISBcuenta cue
					on p.Pquien = cue.Pquien
					and CTtipoUso = 'A'
				inner join ISBproducto co
					on cue.CTid = co.CTid
				inner join ISBlogin lo
					on co.Contratoid = lo.Contratoid			
 			Where ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
		
		
				<!--- Actividades de los Logines de la cuenta del Agente--->
		<cfquery name="rsbitacora" datasource="#session.DSN#">
			Select b.LGlogin, b.BLobs, b.BLfecha, BLusuario, BLautomatica
 				from ISBpersona p
				inner join ISBagente ag
					on p.Pquien = ag.Pquien
				inner join ISBcuenta cue
					on p.Pquien = cue.Pquien
					and CTtipoUso = 'A'
				inner join ISBproducto co
					on cue.CTid = co.CTid
				inner join ISBlogin lo
					on co.Contratoid = lo.Contratoid
				inner join ISBbitacoraLogin b
                    on lo.LGnumero = b.LGnumero				
 			Where ag.AGid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AGid#" null="#Len(form.AGid) is 0#">
		</cfquery>
		
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="2" align="center">
				  <span class="style51">Datos Agente</span></td>
			</tr>
			<cfif isdefined('rsagente') and rsagente.recordCount GT 0>
				<tr>
					  <td width="18%" align="left" nowrap="nowrap" ><strong>C&oacute;digo Agente Autorizado</strong></td>
					  <td width="82%" align="left" nowrap="nowrap" ><strong>Estado</strong></td>				 
				<tr>
				<cfloop query="rsagente" startrow="1">
					<tr>
					  <td align="left">#rsagente.AGid#</td>
					  <td align="left"><cfif rsagente.Habilitado>Activo<cfelse>Inhabilitado</cfif></td>
					</tr>			
				</cfloop>
			<cfelse>
					<tr>
					  <td colspan="2"><label>
					  <div align="center">No existen datos del Agente</div>
					  </label></td>
					</tr>			
			</cfif>
	
		</table>
		<hr>
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="3" align="center">
				 <span class="style51">Datos Contacto</span>
				 </td>
			</tr>
			<cfif isdefined('rscontacto') and rscontacto.recordCount GT 0>
				<tr>
					  <td width="18%" align="left" nowrap="nowrap" ><strong>Identificaci&oacute;n</strong></td>
					  <td width="50%" align="left" nowrap="nowrap" ><strong>Nombre</strong></td>
					  <td width="32%" align="left" nowrap="nowrap" ><strong>Tipo</strong></td>				 
				<tr>
				<cfloop query="rscontacto" startrow="1">
					<tr>
					  <td align="left">#rscontacto.Pid#</td>
					  <td align="left">#rscontacto.Pnombre# #rscontacto.Papellido# #rscontacto.Papellido2#</td>
					  <td align="left"><cfif rscontacto.RJtipo eq 'A'>Administrativo<cfelse>Legal</cfif></td>
					</tr>			
				</cfloop>
			<cfelse>
					<tr>
					  <td colspan="2"><label>
					  <div align="center">No existen datos del Contacto</div>
					  </label></td>
					</tr>			
			</cfif>
	
		</table>
		<hr>		
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="2" align="center" nowrap="nowrap">
				<div  align="center">
				  <span class="style51">Datos de Cuenta</span>
				</div>
			  </td>
			</tr>
			<cfif isdefined('rscuenta') and rscuenta.recordCount GT 0>
				<cfloop query="rscuenta" startrow="1">
					<tr>
					  <td width="18%" align="left" nowrap="nowrap" ><cfif rscuenta.CTtipoUso EQ 'A'>
						<strong>Acceso:</strong>
						<cfelse>
						<strong>Cuenta Especial:</strong>
					  </cfif></td>
					  <td width="82%" align="left"><cfif rscuenta.CUECUE eq 0>&nbsp;Por Asignar<cfelse>&nbsp;#rscuenta.CUECUE#</cfif></td>
					</tr>			
				</cfloop>
					<tr>
						<td width="18%" align="left" nowrap="nowrap" >
						  <a href="##" class="style49" onclick="Javascript: contratos(document.form1);"><u>Seguimiento de Ventas Agente</u></a></td>
					</tr>
			<cfelse>
					<tr>
					  <td colspan="2"><label>
					  <div align="center">No existen cuenta para el Agente</div>
					  </label></td>
					</tr>			
			</cfif>
	
		</table>
				<hr>		
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="4" align="center" nowrap="nowrap">
				<div  align="center">
				  <span class="style51">Datos de Logines</span>
				</div>
			  </td>
			</tr>
			<cfif isdefined('rslogines') and rslogines.recordCount GT 0>
				<tr>
					  <td width="12%" align="left" nowrap="nowrap" ><strong>Login</strong></td>
					  <td width="30%" align="left" nowrap="nowrap" ><strong>Estado</strong></td>
					  <td width="20%" align="left" nowrap="nowrap" ><strong>Bloqueado</strong></td>

				<tr>	
				<cfloop query="rslogines">
				<tr>
					  <td align="left">#rslogines.LGlogin#</td>
					  <td align="left"><cfif rslogines.Habilitado eq 1>Habilitado<cfelseif rslogines.Habilitado eq 2>Borrado<cfelseif rslogines.Habilitado eq 0>Inactivo temporal</cfif></td>
					  <td align="left"><cfif rslogines.LGbloqueado eq 1>Si<cfelse>No</cfif></td>
				</tr>			
				</cfloop>
					<tr><td>&nbsp;&nbsp;</td></tr>
					<tr>				
						<td colspan="2" align="left">
						<div  align="left">
						  <strong>Actividades</strong>
						</div>
						</td>
					</tr>
					<tr>
					  <td width="12%" align="left" nowrap="nowrap" ><strong>Login</strong></td>
					  <td width="52%" align="left" nowrap="nowrap" ><strong>Actividad</strong></td>
					  <td width="19%" align="left" nowrap="nowrap" ><strong>Fecha</strong></td>
					  <td width="17%" align="left" nowrap="nowrap" ><strong>Usuario</strong></td>
					<tr>
					<cfloop query="rsbitacora">
						<tr>
					  		<td align="left">#rsbitacora.LGlogin#</td>
							<td align="left">#rsbitacora.BLobs#</td>
							<td align="left">#LSDateformat(rsbitacora.BLfecha,'dd/mm/yyyy')# #LSDateformat(rsbitacora.BLfecha,'HH:mm:ss')#</td>
							<td align="left">#rsbitacora.BLusuario#</td>
						</tr>
					</cfloop>
			<cfelse>
					<tr>
					  <td colspan="2"><label>
					  <div align="center">No existen Logines para el Agente</div>
					  </label></td>
					</tr>			
			</cfif>
		</table>
		<hr>
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="3" width="100%" >
				  <div  align="center">
				  <span class="style51">Datos de Productos</span>
			   	  </div>
			   </td>
			</tr>
			<cfif isdefined('rsproductos') and rsproductos.recordCount GT 0>
				<tr>
					  <td width="18%" align="left" nowrap="nowrap" ><strong>C&oacute;digo Paquete</strong></td>
					  <td width="50%" align="left" nowrap="nowrap" ><strong>Descripci&oacute;n</strong></td>
					  <td width="32%" align="left" nowrap="nowrap" ><strong>Estado</strong></td>				 
				<tr>	
				<cfloop query="rsproductos">
				<tr>
					  <td align="left">#rsproductos.PQcodigo#</td>
					  <td align="left">#rsproductos.PQdescripcion#</td>
					  <td align="left"><cfif rsproductos.Habilitado>Habilitado<cfelse>Inhabilitado</cfif></td>
				</tr>			
				</cfloop>
			<cfelse>
				<tr>
				  <td colspan="2"><label>
				  <div align="center">No exiten productos asociados al agente</div>
				  </label></td>
				</tr>
			</cfif>
	  </table>
		<hr>
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="2">
				<div align="center"> <span>
				  <span class="style51">Datos de Cobertura</span>
				</div>
			  </td>
			</tr>
			<cfif isdefined('rscobertura') and rscobertura.recordCount GT 0>
				<tr>
					  <td align="left" nowrap="nowrap" ><strong>Localidades</strong></td>
				<tr>	
				<cfloop query="rscobertura" startrow="1">
				<tr>
					  <td align="left">#rscobertura.LCnombre#</td>
				</tr>			
				</cfloop>
			<cfelse>
				<tr>
				  <td colspan="2" width="100%"><label>
				  <div align="center">No existen datos de cobertura para el agente</div>
				  </label></td>
				</tr>
			</cfif>
	  </table>
		<hr>
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="4">
				<div align="center">
				  <span class="style51">Usuario Sistema SACI</span>
				</div>
			  </td>
			</tr>
			<cfif isdefined('rsUsuarioSACI') and rsUsuarioSACI.recordCount GT 0>
				<tr>
					  <td width="15%" align="left" nowrap="nowrap"><strong>Usuario</strong></td>
					  <td width="33%" align="left" nowrap="nowrap"><strong>Estado</strong></td>
				<tr>	
				<cfloop query="rsUsuarioSACI" startrow="1">
				<tr>
					  <td align="left">#rsUsuarioSACI.Usulogin#</td>
					  <td align="left"><cfif rsUsuarioSACI.Uestado>Activo<cfelse>Inactivo</cfif></td>
				</tr>			
				</cfloop>
				<cfif bloqueos.RecordCount>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="15%" align="left" nowrap="nowrap"><strong>Bloqueos</strong></td>
						<tr>
						<tr>
							<td width="15%" align="left" nowrap="nowrap"><strong>Fecha</strong></td>
							<td width="33%" align="left" nowrap="nowrap"><strong>Bloqueado Hasta</strong></td>
							<td width="39%" align="left" nowrap="nowrap"><strong>Razón</strong></td>
							<td width="13%" align="left" nowrap="nowrap"><strong>Desbloqueado</strong></td>
						</tr>
					<cfloop query="bloqueos">	
						<tr>
							  <td align="left">#LSdateformat(bloqueos.fecha,'dd/mm/yyyy')# #LSdateformat(bloqueos.fecha,'HH:mm:ss')#</td>
							  <td align="left">#LSdateformat(bloqueos.bloqueo,'dd/mm/yyyy')# #LSdateformat(bloqueos.bloqueo,'HH:mm:ss')#</td>
							  <td align="left">#bloqueos.razon#</td>
							  <td align="left">#bloqueos.desbloq#</td>
						</tr>
					</cfloop>
				</cfif>
			
			<cfelse>
				<tr>
				  <td colspan="2"><label>
				    <div align="center">No existe datos de Usuario de acceso al Sistema.
			        </div>
			      </label></td>
				</tr>
			</cfif>
	  </table>
		<hr>
		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td colspan="2">
				<div align="center">
				  <span class="style51">Notificaciones</span>
				</div>
			  </td>
			</tr>
			<cfif isdefined('rsEmail') and rsEmail.recordCount GT 0>
				<tr>
				<td width="18%" align="left" nowrap="nowrap"><strong>Lista de Notificaciones</strong></td>
						<cfinvoke component="sif.Componentes.pListas" method="pLista"
							tabla="ISBagenteEmail"
							columnas="AMid,case when AMEinout = 'in' then AMEfrom else AMEto end as fromto
									,AMEsubject,AMEinout,
									AMErecibido,
									case 
										when AMtipo = 'H' then 'Notificación Habilitado'
										when AMtipo = 'I' then 'Notificación Inhabilitación'
										when AMtipo = 'P' then 'Preventiva'
										else 'Tipo de notificación no conocida'
									end AMtipo"	
							filtro="1=1 order by AMErecibido desc"
							desplegar="fromto,AMEsubject,AMtipo,AMErecibido"
							etiquetas="Para,Asunto,Tipo,Fecha Enviado"
							formatos="S,S,S,DT"
							align="left,left,left,left"					
							irA= "agente-resumen.cfm"
							formName= "form1"
							form_method="get"
							keys="AMid"
							mostrar_filtro="yes"
							filtrar_automatico="yes"
							incluyeform="false">
				</tr>
			<cfelse>
				<tr>
				  <td colspan="2"><label>
				    <div align="center">No existe notificaciones para el Agente.
			        </div>
			      </label></td>
				</tr>
			</cfif>
	  </table>

	</cfoutput>
</form>

	<form name="form2" method="post" style="margin: 0;" action="#CurrentPage#">
	<cfoutput>
	<cfinclude template="agente-hiddens.cfm">
	<input type="hidden" name="AGid" value="<cfif isdefined("form.ag") and Len(Trim(form.ag))>#form.ag#</cfif>" />
	<table width="100%" border="0" cellspacing="0" cellpadding="2">
	  <tr>
		<td>
			<cf_botones names="Lista" values="Lista Agentes" tabindex="1">
		</td>
	  </tr>
	</table>
	</cfoutput>
	</form>
</cfif>


	<script type="text/javascript" language="javascript">
		function contratos(formulario) {
		<cfoutput>
			location.href = '../../dso/venta/seguimiento_lista.cfm?AGidp_Agente=' + formulario.AGid.value;
			return false;
		</cfoutput>
		}
	
	</script>




