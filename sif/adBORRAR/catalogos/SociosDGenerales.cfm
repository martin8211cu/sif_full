<!--- 
	Modificado por Gustavo Fonseca Hernández
	Fecha: 9-8-2005.
	Motivo: Se agrega el codigo externo a este tab.

	Modificado por: Ana Villavicencio
	Fecha: 31 de Agosto del 2005
	Motivo: Permitir ingresar la identificación (fiscal o juridica) en caso de q no se tenga una mascara asignada 
			en Parametros Adicionales.
	Lineas: 286
		
 --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfparam name="LvarSNtipo" default="">

<cfquery name="rsEstadoSNegocios" datasource="#Session.DSN#">
	select ESNid, ESNcodigo, ESNdescripcion, ESNfacturacion
	from EstadoSNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsMasks" datasource="#Session.dsn#">
	select J.Pvalor Juridica, F.Pvalor Fisica
	from Parametros J, Parametros F
	where J.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and J.Pcodigo = 620
	  and F.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and F.Pcodigo = 630
</cfquery>

<!---Marcara del Socio de Negocios--->
<cfquery name="rsMasksSN" datasource="#Session.dsn#">
	select Pvalor as MaskSN
	from Parametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo = 611
</cfquery>

<cfset MascaraNumeroSN= 'XXX-XXXX'>

<cfif isdefined("rsMasksSN") and len(trim(rsMasksSN.MaskSN))>
	<cfset MascaraNumeroSN= rsMasksSN.MaskSN>
</cfif>

<cfif rsMasksSN.recordcount EQ 0>
    <cfquery datasource="#Session.dsn#">
        insert into Parametros (
            Ecodigo, 
            Pcodigo, 
            Mcodigo, 
            Pdescripcion, 
            Pvalor
            )
        values (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
            611,
            'CC',
            'Formato de Máscara de Socio de Negocios', 
            'XXX-XXXX'
            )
    </cfquery>
</cfif>

<cfquery name="rsIntercompany" datasource="#Session.dsn#">
	select Edescripcion,Ecodigo
	from Empresas
	order by Edescripcion
</cfquery>

<cfset tengo_hijos = false>
<cfif modo neq 'ALTA' or isdefined("form.SNcodigo") and Len(form.SNcodigo)>
	<cfset modo='CAMBIO'>
	
	<cfquery datasource="#session.dsn#" name="hijos">
		select count(1) as cantidad
		from SNegocios
		where SNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
	</cfquery>
	<cfset tengo_hijos = hijos.cantidad GT 0>
		<cfif hijos.cantidad GT 0>
		  <cfset tengo_hijos = hijos.cantidad>
			<cfquery datasource="#session.dsn#" name="ListaHijos">
				select SNid
				from SNegocios
				where SNidPadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.SNid#">
			</cfquery> 	
			<cfif ListaHijos.recordcount eq 1>
			  <cfset LvarSociosHijos = ListaHijos.SNid>
			<cfelseif ListaHijos.recordcount gt 1>
			  <cfset LvarSociosHijos ="">
			  <cfloop query="ListaHijos">
					<cfset LvarSociosHijos &= ListaHijos.SNid>
				 <cfif ListaHijos.recordcount neq ListaHijos.currentRow>	
					<cfset LvarSociosHijos &=','>
				 </cfif>		
			  </cfloop> 	  	
			</cfif>	 
	  </cfif>	
</cfif> <!--- modo cambio --->

<cfquery name="rsIdiomas" datasource="sifcontrol">
	select rtrim(Icodigo) as LOCIdioma, Descripcion as LOCIdescripcion
	from Idiomas
	order by 1, 2
</cfquery>


<script language="JavaScript" type="text/JavaScript">
<!--

function validar_numeros(obj){
	window.open('SociosRepetidos.cfm?<cfif modo neq 'ALTA'>SNcodigo=#JSStringFormat(url.SNcodigo)#&</cfif>SNnumero=' + escape(obj.value), 'framedupnumero');
}

function validar_identificacion(obj){
	window.open('SociosRepetidos.cfm?<cfif modo neq 'ALTA'>SNcodigo=#JSStringFormat(url.SNcodigo)#&</cfif>SNidentificacion=' + escape(obj.value), 'framedupnumero');
}

function socio_generico(){
	// no se puede borrar el SN generico
	<cfif modo neq 'ALTA'>
		<cfif rsSocios.SNcodigo eq '9999' >
			return true;
		<cfelse>
			return false;
		</cfif>
	<cfelse>
		return false;
	</cfif>	
}

function validarDGenerales(form){
	if(form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo'){
		if(document.form.esIntercompany.checked){
			if(document.form.Intercompany.value == '-1'){
				alert('La empresa a la que pertenece, es requerida.');
				document.form.Intercompany.focus();
				return false;			
			}
		}
	}	

	if ( form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo' ){
		socios_validateForm(form,'SNnumero', '', 'R', 'SNidentificacion','','R','SNnombre','','R','SNemail','','NisEmail','SNFecha','','R');
		return document.MM_returnValue
	}
	else{ 
		if (form.botonSel.value == 'Baja' && socio_generico() ) {
			alert('El Socio de Negocios Genrico no puede ser eliminado.');
			return false;
		}
	}
	
	return true;	
}	

function funcNuevo(){
	location.href='Socios.cfm';
	return false;
}
//-->

</script>

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cf_templatecss>
<!--- <script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script> --->

<body>

<form action="SociosDGenerales-sql.cfm" method="post" name="form" onSubmit="return validarDGenerales(this);">
<cfoutput>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
	<tr>
	  	<td  align="right" valign="top" width="1%">&nbsp;</td>
		<td width="40%" rowspan="4">
			<table>
				<tr>
					<td>
						<strong>N&uacute;mero&nbsp;de&nbsp;Socio</strong>:&nbsp;
					</td>
					<td>
						<cfif Modo neq 'ALTA'>
							<strong>Empresa origen: </strong>
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap>
						<input tabindex="1" type="text" size="12" maxlength="11" name="SNnumero" value="<cfif modo neq 'ALTA'>#Trim(rsSocios.SNnumero)#</cfif>"
							   onFocus="javascript:this.select();"	
							   alt="El N&uacute;mero de Socio" >&nbsp; <b>#MascaraNumeroSN#</b>	
							   <iframe  tabindex="-1" width="1" height="1" frameborder="0" style="display:none;" name="framedupnumero" id="framedupnumero" src="about:blank"></iframe>
								&nbsp;&nbsp;
					</td>
					<td>
						<cfif Modo neq 'ALTA'>
							<cfoutput>#HTMLEditFormat(rsSocios.EnombreInclusion)#</cfoutput>
							<cfif modalidad.readonly>
							  (modicaciones restringidas) 
							</cfif>
						<cfelseif Len(session.EcodigoCorp) And (session.Ecodigo neq session.EcodigoCorp)>
							<cfset ac_disabled = not modalidad.altalocal or not modalidad.altacorp>
							<cfset ac_checked = modalidad.altacorp>
							<input  tabindex="1" type="checkbox" name="ALTA_CORPORATIVO" id="ALTA_CORPORATIVO" value="1"
								<cfif ac_disabled>disabled</cfif> <cfif ac_checked>checked</cfif> 
							>
							<label for="ALTA_CORPORATIVO"><strong>Generar Socio en Corporaci&oacute;n</strong></label>
						</cfif>
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap><strong>Tipo&nbsp;de&nbsp;persona:</strong>&nbsp;</td>
			      	<td valign="top"><strong>Identificaci&oacute;n:</strong>&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
				<cfif modo EQ "ALTA"> <!---rsMasks.Fisica  se manda el campo como hidden para poder deshabilitarlo en cambio --->
					<cfset LvarSNtipo = rsMasks.Fisica>
					<select  tabindex="1" name="SNtipo" id="SNtipo" <cfif LvarSNtipo NEQ ''>onChange="getMask(false,SNMid)"</cfif>>
						<option value="F" <cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>selected</cfif>>Física</option>
						<option value="J" <cfif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>selected</cfif>>Jurídica</option>
						<option value="E" <cfif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>selected</cfif>>Extranjero</option>
					</select>
                    
				<cfelse>
					<cfif (isDefined("rsSocios.SNtipo") AND "F" EQ rsSocios.SNtipo)>
						<cfset LvarSNtipo = rsMasks.Fisica>
						<input  tabindex="-1" type="hidden" value="F" name="SNtipo" id="SNtipo">
						<input  tabindex="1" type="text" readonly value="Física" style="border:none;" size="10">
					<cfelseif (isDefined("rsSocios.SNtipo") AND "J" EQ rsSocios.SNtipo)>
						<cfset LvarSNtipo = rsMasks.Juridica>
						<input tabindex="-1" type="hidden" value="J" name="SNtipo" id="SNtipo">
						<input  tabindex="1" type="text" readonly value="Juríica" style="border:none;" size="10">
					<cfelseif (isDefined("rsSocios.SNtipo") AND "E" EQ rsSocios.SNtipo)>
						<cfset LvarSNtipo = RepeatString("*", 30)>
						<input tabindex="-1" type="hidden" value="E" name="SNtipo" id="SNtipo">
						<input  tabindex="1" type="text" readonly value="Extranjero" style="border:none;" size="10">
					</cfif>
				</cfif>
                <!---►►►►MASCARAS DE LOS SOCIOS DE NEGOCIO◄◄◄◄--->
              			<cfinvoke component="sif.Componentes.SocioNegocios" method="GetSNMascaras" returnvariable="rsSNMascaras"></cfinvoke>
                        <script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
                		<BR>&nbsp;&nbsp;
                		<select tabindex="1" name="SNMid" id="SNMid" onChange="getMask('true',this.value)">
                        	<option value="">--Ninguno--</option>
						</select>
					</td>
					<td>
						<!---<cfif modo NEQ "ALTA" and Len(Trim(rsSocios.SNidentificacion))> readonly </cfif>--->
						<input  tabindex="1" type="text" name="SNidentificacion" id="SNidentificacion" size="50"
							 value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNidentificacion)#</cfif>" 
							 onfocus="javascript:this.select();" 
							 alt="Identificación" >
						<input  tabindex="-1" type="text" name="SNmask" size="50" readonly value="#LvarSNtipo#" style="border:none;">
						<input  tabindex="-1" type="hidden" name="SNidentificacion_BD" value="<cfif modo NEQ "ALTA" >#trim(rsSocios.SNidentificacion)#</cfif>">
					</td>
				</tr>
				<tr>
					<td valign="top" nowrap>
                    	
                    </td>
			      	<td valign="top"><strong>Identificaci&oacute;n (Secundaria):</strong>&nbsp;</td>
				</tr>	
				<tr>
					<td valign="top" nowrap>&nbsp;</td>
			      	<td valign="top">
						<input  tabindex="1" type="text" name="SNidentificacion2" size="20" maxlength="20"
						 onblur="javascript:ValidarID(this);"
						 value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNidentificacion2)#</cfif>" 
						 onfocus="javascript:this.select();" 
						 alt="Identificación (adicional)" >					
					</td>
				</tr>				
			</table>
		</td>

		<td width="10%">
		</td>
		<td width="40%">
			<strong>Fecha: </strong>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
		<td>&nbsp;</td>	
		<td valign="top">
			<input tabindex="1" type="text" name="SNFecha" readonly size="12" value="<cfif #modo# NEQ "ALTA">#LSDateFormat(rsSocios.SNFecha, 'dd/mm/yyyy')#<cfelse>#LSDateFormat(Now(),"DD/MM/YYYY")#</cfif>" alt="El campo Fecha de inclusin del Socio">
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>	
		<td>&nbsp;</td>	
	    <td valign="middle">
			<cfif modo neq 'ALTA'>
				<input  tabindex="1" type="checkbox" name="SNinactivo" id="SNinactivo" <cfif modalidad.readonly or (modo NEQ "ALTA" and rsSocios.SNcodigo eq 9999)>disabled</cfif> value="1" 
					<cfif modo NEQ "ALTA" and rsSocios.SNinactivo EQ 1>checked</cfif>>
				<label for="SNinactivo"><strong>Inactivo</strong></label>
			</cfif>
			&nbsp;
			<cfif modo neq 'ALTA'>
				<cfif modalidad.modalidad>
					<input  tabindex="1" type="checkbox" name="es_corporativo" id="es_corporativo" value=""
						<cfif Len(rsSocios.SNidCorporativo)>checked</cfif>
						disabled><label for="es_corporativo"><strong>Cliente corporativo</strong></label>
				</cfif>
			</cfif>
		</td>
	</tr>

	<tr>
		<td>&nbsp;</td>	
		<td>&nbsp;</td>	
	  <td>
			<input  tabindex="1" type="checkbox" name="esIntercompany" value="1"
				<cfif modalidad.readonly> disabled</cfif>
				<cfif modo NEQ "ALTA" and rsSocios.esIntercompany EQ 1> checked</cfif>>	    
		    <strong>Inter Company</strong></td>	
	</tr>

	<tr>
	  <td align="right" valign="top" nowrap>&nbsp;</td>
	  <td colspan="2" valign="top"><strong>Nombre:</strong>&nbsp;</td>
      <td valign="top"><strong>Grupo Socio de Negocios:</strong>&nbsp;</td>
	</tr>
	<tr> 
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td colspan="2" valign="top">
			<input tabindex="1" type="text" name="SNnombre" size="75" style="width:400px" maxlength="255" <cfif modalidad.readonly>readonly</cfif> value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNnombre)#</cfif>" onFocus="javascript:this.select();"  alt="El campo Nombre del Socio">
		</td>
		<td valign="middle"> 
			<cfif modo neq 'ALTA' and rsSocios.GSNid gt 0>
				<cfquery name="rsGrupoSNCon" datasource="#session.DSN#">
					select a.GSNid, a.GSNcodigo, a.GSNdescripcion 
					from GrupoSNegocios a, GrupoSNegocios b
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocios.GSNid#">
						and a.Ecodigo = b.Ecodigo
						and a.GSNid = b.GSNid			
				</cfquery>
	
				<cf_sifGrupoSN  tabindex="1" form ="form" query =#rsGrupoSNCon#>		
			<cfelse>
				<cf_sifGrupoSN  tabindex="1" form ="form">
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td valign="baseline"><strong>C&oacute;digo&nbsp;Socio&nbsp;en&nbsp;Sistema&nbsp;Externo:</strong></td>
		<td align="right" valign="top" nowrap>&nbsp;</td>
	<td valign="top" nowrap><strong>Empresa a la que Pertenece </strong></td>
	</tr>
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td valign="baseline"> 
			<input  tabindex="1" name="SNcodigoext" type="text" size="30"  maxlength="25" value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNcodigoext)#</cfif>" ><!---- onFocus="javascript:this.select();" ----->
		</td>
		<td align="right" valign="top" nowrap>&nbsp;</td>
	<td valign="top" nowrap>
		<select  tabindex="1" name="Intercompany" id="Intercompany">
			<option value="-1">- Ninguna -</option>
			<cfif isdefined('rsIntercompany') and rsIntercompany.recordCount GT 0>			
 				<cfloop query="rsIntercompany">
					<option value="#rsIntercompany.Ecodigo#" <cfif modo NEQ 'ALTA' and rsIntercompany.Ecodigo EQ rsSocios.Intercompany>selected</cfif>>#HTMLEditFormat(rsIntercompany.Edescripcion)#</option>
				</cfloop>
			</cfif>
	  	</select>
	</td>
	</tr>

	
	
	
	<tr>
		<td align="right" valign="top" nowrap>&nbsp;</td>
		<td colspan="2" valign="middle"><!--- <strong>Categora del Socio de Negocios:</strong> --->&nbsp;</td>
		<td valign="top"><strong>Socio Relacionado: </strong></td>
	</tr>
	<tr>
		<td rowspan="11">&nbsp;</td>
		<td colspan="2" valign="top"> 
			<input  tabindex="1" type="checkbox" name="SNcertificado" id="SNcertificado" <cfif modo NEQ "ALTA" and rsSocios.SNcertificado eq 9999 or modalidad.readonly>disabled</cfif> value="1" 
			<cfif modo NEQ "ALTA" and rsSocios.SNcertificado EQ 1>checked</cfif> >
			<label for="SNcertificado"><strong>Certificado&nbsp;ISO</strong></label>
		</td>
		<td valign="top">
			<cfif modo neq 'ALTA'>
				<cfset SNcodigoPadre = rsSocios.SNcodigoPadre>
				<cfset excepto = rsSocios.SNid>
			<cfelse>
				<cfset SNcodigoPadre = "">
				<cfset excepto = "">
			</cfif>
			<cfif not tengo_hijos>
				<!---
					si tengo hijos, no puede adoptar un padre.  de esta manera se evitan jerarquias
					adicionalemente, sifsociosrelacionados evita los que tengan papa
				 --->
				<cf_sifsocios_relac tabindex="1" form="form" SNcodigo="SNcodigoPadre" SNnombre="SNnombrePadre" SNnumero="SNnumeroPadre" idquery="#SNcodigoPadre#"
					excepto="#excepto#">
			<cfelse>
				No se puede relacionar, ya que hay otros socios relacionados con &eacute;ste.
				 <img alt="Ver Socios que referencian" title="Ver Socios que referencian"  border="0" src="/cfmx/sif/imagenes/find.small.png" onClick="VerSocios('<cfoutput>#LvarSociosHijos#</cfoutput>')">
				<input  tabindex="-1" type="hidden" name="SNcodigoPadre" value="">
			</cfif>
		</td>
	</tr>
	<tr>
	  <td colspan="2" rowspan="10" valign="top">
			<cfif IsDefined('rsSocios.id_direccion') And Len(rsSocios.id_direccion)>
				<!--- <cfdump var="#rsSocios.id_direccion#"> --->
				<cfif modalidad.readonly>
					<div style="width:80% ">
		          		<cf_sifdireccion tabindex="1" action="display" key="#rsSocios.id_direccion#">
					</div>
				<cfelse>
		          <cf_sifdireccion tabindex="1" action="input" key="#rsSocios.id_direccion#">
				</cfif>
			<cfelse>
				
		          <cf_sifdireccion  tabindex="1" action="input">
			</cfif></td>
	  <td valign="top"><strong>Tel&eacute;fono:&nbsp;</strong></td>
	</tr>
	<tr>
	  <td valign="top"><input  tabindex="1" name="SNtelefono" type="text" size="30" maxlength="30" value="<cfif #modo# NEQ "ALTA">#trim(rsSocios.SNtelefono)#</cfif>" onFocus="javascript:this.select();" alt="El campo Tel&eacute;fono del Socio" <cfif modalidad.readonly>disabled</cfif>>
      </td>
	</tr>
	<tr>
	  <td valign="top"><strong>Fax:&nbsp;</strong></td>
	</tr>
	<tr>
	  <td valign="top"><input  tabindex="1" name="SNFax" type="text" onFocus="javascript:this.select();" value="<cfif modo NEQ "ALTA">#trim(rsSocios.SNFax)#</cfif>" size="30" maxlength="30" alt="El campo Fax del Socio "  <cfif modalidad.readonly>disabled</cfif>></td>
	</tr>	

	
	<tr>
	  <td valign="top"><strong>Correo&nbsp;electr&oacute;nico:</strong></td>
	</tr>
	<tr>
	  <td valign="top"><input  tabindex="1" name="SNemail" type="text" size="75" style="width:400px"  maxlength="100" onBlur="return document.MM_returnValue" value="<cfif modo NEQ "ALTA">#Trim(rsSocios.SNemail)#</cfif>" onFocus="javascript:this.select();" alt="El campo E-Mail del Socio " <cfif modalidad.readonly>disabled</cfif>>
      </td>
	</tr>
	<tr>
	  <td valign="top"><strong>Estado Socio de Negocios:</strong>&nbsp;</td>
	</tr>
	<tr>
	  <td valign="top">
		  <select  tabindex="1" name="ESNid" id="ESNid" <cfif modalidad.readonly>disabled</cfif>>
			  <cfloop query="rsEstadoSNegocios">
				  <option value="#rsEstadoSNegocios.ESNid#" <cfif modo NEQ 'ALTA' and rsEstadoSNegocios.ESNid EQ rsSocios.ESNid>selected</cfif>>#HTMLEditFormat(rsEstadoSNegocios.ESNdescripcion)#</option>
			  </cfloop>
       	  </select>
	  </td>
	</tr>
	
	<tr>
	  <td valign="top" ><strong>Idioma:&nbsp;</strong></td>
	</tr>
	<tr>
	  <td height="26" valign="top" >
		  <select  tabindex="1" name="LOCIdioma" id="LOCIdioma" <cfif modalidad.readonly>disabled</cfif>>
			  <option value="">-- Ninguno --</option>			
           	  <cfloop query="rsIdiomas">
           		  <option value="#rsIdiomas.LOCIdioma#" <cfif modo NEQ 'ALTA' and rsIdiomas.LOCIdioma EQ rsSocios.LOCIdioma>selected</cfif>>#HTMLEditFormat(rsIdiomas.LOCIdescripcion)#</option>
			  </cfloop>
       	  </select>
	  </td>
	</tr>
	<tr>
		<td height="26" align="right" valign="top" nowrap>&nbsp;</td>
		<td height="26" colspan="2" align="left" valign="middle">
			<cfif modo neq 'ALTA'>
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec"/>
				<cfset usuario_existente = sec.getUsuarioByRef(form.SNcodigo, Session.EcodigoSDC, 'SNegocios')>
				<cfif usuario_existente.RecordCount>
					<cfif usuario_existente.Utemporal>
						<cfset el_login='Temporal'>
					<cfelseif not usuario_existente.Uestado>
						<cfset el_login='Inactivo. Consulte con el administrador de la seguridad'>
					<cfelse>
						<cfset el_login=usuario_existente.Usulogin>
					</cfif>
				<cfelse>
					<cfset el_login='No se ha asignado usuario'>
				</cfif>
					<strong>Usuario&nbsp;asignado&nbsp;para&nbsp;uso&nbsp;del&nbsp;Sistema:</strong>&nbsp;#HTMLEditFormat(el_login)#
			</cfif></td>
		<td>
		</td>
	</tr>
	
	<tr>
	  	<td colspan="4" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<!--- Botones --->
	<tr> 
		<td colspan="4" align="center" valign="top" nowrap> 
			<div align="center"> 
				<!--- funcActivarUsuario ya est definido en SociosICrediticia --->
				<cfif modo eq 'CAMBIO'>
					<cf_botones tabindex="2" modo="#modo#" include="ActivarUsuario,Direcciones" IncludeValues="Activar como Usuario,Direcciones">
				<cfelse>
					<cf_botones tabindex="2" modo="#modo#">
				</cfif>
				 <!--- <cf_botones modo="#modo#" include="ActivarUsuario" IncludeValues="Activar como Usuario" exclude="#excludeButtons#">  --->
			</div>
		</td>
	</tr>
	<tr>
	  	<td colspan="4" align="right" valign="top" nowrap>&nbsp;</td>
    </tr>
	<cfif modo neq "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSocios.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input  tabindex="-1" type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
  	<input  tabindex="-1" type="hidden" name="SNcodigo" value="<cfif modo NEQ "ALTA">#rsSocios.SNcodigo#</cfif>">
	<input  tabindex="-1" type="hidden" name="DGenerales" value="DGenerales">
</table>
</form>
<!--- Frame para validar que no se repitan la identificación secundaria del socio de negocios --->
<iframe frameborder="0" name="fr" height="0" width="0" src=""></iframe>
</cfoutput>
<cfoutput>
<script language="javascript" type="text/javascript">
function ValidarID(obj) {
			var identificacion = obj.value;
			<cfoutput>
			<cfif (modo neq "ALTA")>
				document.all["fr"].src="valida_ID2.cfm?SNcodigo=#form.SNcodigo#&SNidentificacion2="+identificacion;
			<cfelse>
				document.all["fr"].src="valida_ID2.cfm?SNidentificacion2="+identificacion;
			</cfif>
			</cfoutput>			
		}
<!---
Formato del js Mask: x=letras, #=Numeros *=Ambos  
Formato del usuario: X=letras, ?=Numeros *=Ambos  
--->
function getMask(seleccionar,SNMid)
{
	<cfwddx action="cfml2js" input="#rsSNMascaras#" topLevelVariable="SNMascaras"> 
	var inpSNtipo   = document.getElementById("SNtipo");
	var inpSNMid    = document.getElementById("SNMid");
	var inpIdenti   = document.getElementById("SNidentificacion");
	var CantCombo   = 0;
 	var nRows       = SNMascaras.getRowCount(); 
	var usarMaskPar = true;
	var oCedulaMask = new Mask("#replace(LvarSNtipo,'X','##','ALL')#", "string");
		oCedulaMask.attach(document.form.SNidentificacion, oCedulaMask.mask, "string");
	//Elimina Todos los Valor del combo de Mascaras Extendidas, excepto el Index 0
	for(row = 1; row < inpSNMid.length; ++row)
		inpSNMid.options[row] = null
	//Si existen mascaras extendidas para la empresa	
 	if(nRows > 0)
	{
			for(row = 0; row < nRows; ++row)
			{
				//Si la mascara extendida es del tipo de indentificacion del Socio de Negocio Actual
				if (SNMascaras.getField(row, "SNtipo") == inpSNtipo.value)
				{
					//Si La mascara Extendida Actual es la que ya posse el SN, por lo que se coloca como seleccionada, de lo contrario coloca el defaultSelected
					if(seleccionar && SNMid == SNMascaras.getField(row, "SNMid"))
						selected = true;
					else
						selected = false;
					CantCombo++;
					valorCombo = new Option(SNMascaras.getField(row, "SNMDescripcion"),SNMascaras.getField(row, "SNMid"),0,selected)
					inpSNMid.options[inpSNMid.length] = valorCombo;
					if (selected)
					{
						usarMaskPar 	 = false;
						masktemp         = SNMascaras.getField(row,"SNMascara").replace(/X/g,'x');
						oCedulaMask.mask = masktemp.replace(/\?/g,'##');
						document.form.SNmask.value = SNMascaras.getField(row,"SNMascara");
					}
				}
			}
			//Si posse Mascaras Extendidas para el tipo de Indentificacion pinta el combo de lo contrario lo oculta
			if(CantCombo > 0)
				inpSNMid.style.display   = "";	
			else 
				inpSNMid.style.display   = "none";	
	}
	//No existen mascaras extenidas para la empresa
	else
		inpSNMid.style.display   = "none";	
	//Aplica la mascara de los parametros
		 if (usarMaskPar)
		 {
			if (inpSNtipo.value == 'F')
			{
				oCedulaMask.mask 		   = "#replace(replace(rsMasks.Fisica,'X','x','ALL'),'?','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Fisica#";
			}
			else if (inpSNtipo.value == 'J')
			{
				oCedulaMask.mask 		   = "#replace(replace(rsMasks.Juridica,'X','x','ALL'),'?','##','ALL')#";
				document.form.SNmask.value = "#rsMasks.Juridica#";
			}
			else if (inpSNtipo.value== 'E')
			{			
				oCedulaMask.mask = "#RepeatString("*", 30)#";
				document.form.SNmask.value = "";
			}
		 }
		 inpIdenti.onblur();
}
<cfif modo NEQ 'ALTA' AND LEN(rsSocios.SNMid)>
	getMask('true',#rsSocios.SNMid#);
<cfelse>
	getMask('false',-1);
</cfif>
function VerSocios(Hijos){
    window.open('SociosRelacionados.cfm?Socio=' + Hijos + '','popup','width=450,height=400');
}

</script>
</cfoutput>