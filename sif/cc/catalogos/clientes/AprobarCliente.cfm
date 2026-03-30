<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 30 de mayo del 2005
	Motivo:	corrección de nombre en la llamada de un componente, problema con mayusculas y minusculas que se presenta en servidores linux.
	Linea:  58 DBUtils --> DButils
----------->
<cfif isdefined('url.Pagina')>
	<cfset form.Pagina = url.Pagina>
</cfif>
<cfif isdefined('url.Filtro_CDIdentificacion') and LEN(TRIM(url.Filtro_CDIdentificacion))>
	<cfset form.Filtro_CDIdentificacion=url.Filtro_CDIdentificacion>
</cfif>
<cfif isdefined('url.Filtro_CDnombre') and LEN(TRIM(url.Filtro_CDnombre))>
	<cfset form.Filtro_CDnombre=url.Filtro_CDnombre>
</cfif>
<cfif isdefined('url.Filtro_rotulo') and LEN(TRIM(url.Filtro_rotulo))>
	<cfset form.Filtro_rotulo=url.Filtro_rotulo>
</cfif>
<cfset params = ''>
<cfif isdefined('form.Pagina')>
	<cfset params = params & '&Pagina=#form.Pagina#'>
</cfif>
<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
	<cfset params = params & '&Filtro_CDIdentificacion=#form.Filtro_CDIdentificacion#'>
</cfif>
<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
	<cfset params = params & '&Filtro_CDnombre=#form.Filtro_CDnombre#'>
</cfif>
<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
	<cfset params = params & '&Filtro_rotulo=#form.Filtro_rotulo#'>
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<cfif IsDefined('url.CDid')><cfset form.CDid=url.CDid></cfif>
			<cfparam name="form.CDid" type="numeric">
			<cfparam name="form.TDid" type="numeric" default="0">
			<cfparam name="form.CDDid" type="numeric" default="0">
			
			<cfquery name="rsClienteDetallista" datasource="#Session.DSN#" >
				Select
					cd.CEcodigo ,cd.CDid ,cd.CDTid , cd.CDactivo,
					case when cd.CDactivo = 'P' then 'En Proceso' when cd.CDactivo = 'A' then 'Aprobado' 
						when cd.CDactivo = 'R' then 'Rechazado'
						when cd.CDactivo = 'I' then 'Inactivo' else 'No definido' end as rotulo, 
					
					cd.CDidentificacion ,cd.CDnombre ,cd.CDapellido1 ,cd.CDapellido2 ,cd.CDdireccion1 ,cd.CDdireccion2 ,cd.CDpais, cd.CDciudad  ,
					cd.CDestado ,cd.CDcodPostal ,cd.CDoficina ,cd.CDcasa ,cd.CDcelular ,cd.CDfax ,cd.CDemail ,cd.CDcivil ,cd.CDfechanac ,
					cd.CDingreso ,cd.CDsexo, cd.CDtrabajo ,cd.CDantiguedad ,
					cd.CDvivienda ,cd.CDrefcredito ,cd.CDrefbancaria ,cd.CDestudios, cd.CDdependientes, cd.ts_rversion ,
					p.Pnombre, cdt.CDTdescripcion
				from ClienteDetallista cd
					left join Pais p
						on cd.CDpais = p.Ppais
					left join ClienteDetallistaTipo cdt
						on cdt.CDTid = cd.CDTid
				where cd.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				  and cd.CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
			</cfquery>
			
			<cfquery name="documentos" datasource="#session.dsn#">
				select a.CDid, a.TDid, a.CDDid, a.CDDfecha, b.TDdescripcion, a.CDDvalidohasta
				from ClienteDetallistaDoc a
					join ClienteDetallistaTipoDoc b
						on a.CEcodigo = b.CEcodigo
						and a.TDid = b.TDid
				where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				and a.CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		  
				order by a.CDDfecha, b.TDdescripcion, a.CDDvalidohasta
			</cfquery>
			
			<cfquery name="data" datasource="#session.dsn#">
				select *
				from ClienteDetallistaDoc
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.CEcodigo#">
				  and CDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDid#" >		
				  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#" >		
				  and CDDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDDid#" >
			</cfquery>
			<cfinvoke component="sif.Componentes.DButils" method="toTimestamp" arTimeStamp='#data.ts_rversion#' returnvariable="ts" />
	
			<table width="899"  align="center" cellpadding="0" cellspacing="0">
			  <!--DWLayoutTable-->
				<tr>
					<td colspan="2" valign="top">
						
					</td>
					<td width="213" valign="top"></td>
					<td width="182" valign="top"></td>
					<td width="19" valign="top"></td>
					<td width="22" valign="top"></td>
					<td width="179" valign="top"></td>
					<td width="224" valign="top"></td>
					<td width="26" valign="top"></td>
				</tr>
				<tr> 
					<td colspan="9" align="center">									
						<font size="3">
							<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
								Aprobaci&oacute;n de Clientes </strong>
						</font>
					</td>
				</tr>	
				<tr> 
					<td colspan="9" align="center">
						<font size="2">
							<strong> Cliente: </strong><cfoutput>#rsClienteDetallista.CDidentificacion# &nbsp; - &nbsp; #rsClienteDetallista.CDnombre# &nbsp;#rsClienteDetallista.CDapellido1# &nbsp;#rsClienteDetallista.CDapellido2# </cfoutput>
					  </font>
				  </td>
				</tr>
				<tr >
					<td width="15"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td width="17"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td align="center" valign="top">&nbsp;</td>
					<td align="center" valign="top">&nbsp;</td>
					<td align="center" valign="top">&nbsp;</td>
				</tr>
				<tr >
					<td>&nbsp;</td>
				  	<td colspan="3" valign="top" class="subTitulo listaCorte">							    Datos Personales</td>
					<td>&nbsp;</td>
					<td colspan="3" valign="top" class="subTitulo listaCorte">
						Datos F&iacute;sicos:</td>
					<td>&nbsp;</td>
	  			</tr>
				
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><strong>Nombre:</strong>&nbsp;</td>
		  			<td align="left" valign="top" nowrap ><strong>Identificaci&oacute;n:</strong>&nbsp;</td>
	      			<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="2" valign="top" nowrap><strong>Direcci&oacute;n:</strong>&nbsp;</td>
					<td></td>
	  			</tr>
				<tr >
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><cfoutput>#rsClienteDetallista.CDnombre#</cfoutput></td>
		  			<td align="left" valign="top" nowrap><cfoutput>#rsClienteDetallista.CDidentificacion#</cfoutput></td>
					<cfif rsClienteDetallista.CDsexo EQ 'M'><cfset sexo='Masculino'>
    				<cfelseif rsClienteDetallista.CDsexo EQ 'F'><cfset sexo='Femenino'>
    				<cfelse><cfset sexo=rsClienteDetallista.CDsexo></cfif>
	      			<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="2" valign="top"><cfoutput>#rsClienteDetallista.CDdireccion1#</cfoutput></td>
					<td>&nbsp;</td>
	  			</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><strong>Primer Apellido:</strong>&nbsp;</td>
		  			<td align="left" valign="top" nowrap><strong>Segundo Apellido:</strong>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="2" valign="top"><cfoutput>#rsClienteDetallista.CDdireccion2#</cfoutput></td>
					<td></td>
	  			</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td valign="top"><cfoutput>#rsClienteDetallista.CDapellido1#</cfoutput></td>
		  			<td valign="top"><cfoutput>#rsClienteDetallista.CDapellido2#</cfoutput></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><!--DWLayoutEmptyCell-->&nbsp;</td>
		  			<td align="left" valign="top" nowrap><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td>&nbsp;</td>
	  			</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><strong>Estado Civil:</strong></td>
		  			<td align="left" valign="top" nowrap><strong>Fecha Nacimiento:</strong>&nbsp;</td>
		  			<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><strong>Pa&iacute;s:</strong>&nbsp;&nbsp;</td>
					<td align="left" valign="top" nowrap><strong>Ciudad:</strong></td>
					<td>&nbsp;</td>
	  			</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<cfif  rsClienteDetallista.CDcivil EQ 0> 
						<cfset estado_civil='Soltero(a)'>
					<cfelseif  rsClienteDetallista.CDcivil EQ 1> <cfset estado_civil=' Casado(a)'>
					<cfelseif  rsClienteDetallista.CDcivil EQ 2><cfset estado_civil=' Divorciado(a)'>
					<cfelseif  rsClienteDetallista.CDcivil EQ 3> <cfset estado_civil='Viudo(a)'>
					<cfelseif  rsClienteDetallista.CDcivil EQ 4> <cfset estado_civil='Unión Libre'>
					<cfelseif  rsClienteDetallista.CDcivil EQ 5><cfset estado_civil=' Separado'><cfelse>
					  <cfset estado_civil=rsClienteDetallista.CDcivil>
					</cfif> 				 
					<td rowspan="3"  valign="top"><cfoutput>#estado_civil#</cfoutput> </td>
		  			<td rowspan="3" valign="top" nowrap><cfoutput>#dateformat(rsClienteDetallista.CDfechanac,"dd/mm/yyyy")#</cfoutput></td>
		  			<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td valign="top" nowrap><cfoutput>#rsClienteDetallista.Pnombre# </cfoutput> </td>
					<td valign="top" nowrap><cfoutput>#rsClienteDetallista.CDciudad#</cfoutput> </td>
					<td></td>
				</tr>
				<tr>
					<td rowspan="2">&nbsp;</td>
					<td rowspan="2">&nbsp;</td>
					<td rowspan="2">&nbsp;</td>
					<td rowspan="2">&nbsp;</td>
					<td align="left" valign="top" nowrap ><strong>C&oacute;digo Postal:</strong></td>
					<td align="left" valign="top" nowrap ><strong>Provincia o Estado:</strong></td>
					<td rowspan="2">&nbsp;</td>
	  			</tr>
				<tr>
					<td valign="top" ><cfoutput>#rsClienteDetallista.CDcodPostal#</cfoutput></td>
					<td valign="top" ><cfoutput>#rsClienteDetallista.CDestado#</cfoutput></td>
			  	</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap><strong>Tipo de Cliente:</strong>&nbsp; </td>
		  			<td align="left" valign="top" nowrap><strong>Sexo:</strong></td>
	  				<td>&nbsp;</td>
					<td colspan="3" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td>&nbsp;</td>
	  			</tr>
				<tr >
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="left" valign="top" nowrap>
						<cfoutput>#rsClienteDetallista.CDTdescripcion#</cfoutput>
						<cfif len(rsClienteDetallista.CDTdescripcion) is 0>No especificado</cfif>
					</td>
		  			<td align="left" valign="top" nowrap><cfoutput>#sexo#</cfoutput></td>
					<td>&nbsp;</td>
					<td colspan="3" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td></td>
	  			</tr>
				<tr><td colspan="10">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3" valign="top" class="subTitulo listaCorte">Datos de Contacto</td>
					<td>&nbsp;</td>
					<td colspan="3" valign="top" class="subTitulo listaCorte">Perfil Econ&oacute;mico </td>
					<td>&nbsp;</td>
	  			</tr>
				<tr >
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td class="fileLabel"><strong>Tel&eacute;fono de Residencia </strong></td>
					<td valign="top"><span class="fileLabel"><strong>Tel&eacute;fono Celular</strong></span></td>
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td align="left" nowrap ><strong>Trabajo:</strong></td>
					<td align="left" nowrap><strong>Antig&uuml;edad:</strong></td>
					<td>&nbsp;</td>
	  			</tr>
				<tr >
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td><cfoutput>#rsClienteDetallista.CDcasa#</cfoutput></td>
					<td valign="top"><cfoutput>#rsClienteDetallista.CDcelular#</cfoutput></td>
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td nowrap ><cfoutput>#rsClienteDetallista.CDtrabajo#</cfoutput> </td>
					<td align="left" nowrap><cfoutput>#rsClienteDetallista.CDantiguedad#</cfoutput> </td>
					<td>&nbsp;</td>
	  			</tr>
				<tr >
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td class="fileLabel"><strong>Tel&eacute;fono de Oficina </strong></td>
					<td valign="top"><span class="fileLabel"><strong>Fax</strong></span></td>
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td align="left" nowrap><strong>Estudios:</strong>&nbsp;&nbsp;</td>
					<td align="left" nowrap><strong>Dependientes:</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr >
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td><cfoutput>#rsClienteDetallista.CDoficina#</cfoutput> </td>
					<td valign="top"><cfoutput>#rsClienteDetallista.CDfax#</cfoutput></td>
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<cfif rsClienteDetallista.CDestudios EQ ''> <cfset estudios='No especificada'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '1'>  <cfset estudios='Primaria Incompleta'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '2'>  <cfset estudios='Primaria Completa'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '3'>  <cfset estudios='Secundaria Incompleta'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '4'>  <cfset estudios='Secundaria Completa'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '5'>  <cfset estudios='T&eacute;cnica Incompleta'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '6'>  <cfset estudios='T&eacute;cnica Completa'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '7'>  <cfset estudios='Universitaria Incompleta'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '8'>  <cfset estudios='Universitaria Completa'>
					  <cfelseif rsClienteDetallista.CDestudios EQ '9'>  <cfset estudios='Postgrado'>
					  <cfelse><cfset estudios=rsClienteDetallista.CDestudios></cfif>
					<td ><cfoutput>#estudios#</cfoutput>
					  &nbsp;
					</td>
					<td align="left" nowrap><cfoutput>#rsClienteDetallista.CDdependientes#</cfoutput> </td>
					<td>&nbsp;</td>
				</tr>
				<tr >
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td><strong>Direcci&oacute;n Electr&oacute;nica:</strong></td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td align="left" nowrap><strong>Vivienda:</strong></td>
					<td align="left" nowrap><strong>Ingresos Mensuales:</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr >
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td><cfoutput>#rsClienteDetallista.CDemail#</cfoutput> </td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td>&nbsp;</td>
					<td valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<cfif rsClienteDetallista.CDvivienda EQ 'A'>  <cfset vivienda='Alquilada '>
					  <cfelseif rsClienteDetallista.CDvivienda EQ 'H'> <cfset vivienda='Hipotecada '>
					  <cfelseif rsClienteDetallista.CDvivienda EQ 'P'> <cfset vivienda='Propia '>
					  <cfelseif rsClienteDetallista.CDvivienda EQ 'H'> <cfset vivienda='Vive con familiares'>
					  <cfelse><cfset vivienda=rsClienteDetallista.CDvivienda ></cfif>
					<td ><cfoutput>#vivienda#</cfoutput>&nbsp;
					</td>
					<td><cfoutput>#LSCurrencyFormat(rsClienteDetallista.CDingreso, 'none')#</cfoutput> </td>
					<td>&nbsp;</td>
				</tr>
				<tr><td colspan="10">&nbsp;</td></tr>
				<tr >
					<td>&nbsp;</td>
					<td colspan="3" valign="top" class="subTitulo listaCorte">Referencias Crediticias</td>
					<td align="center" valign="top">&nbsp;</td>
					<td colspan="3" align="center" valign="top" class="subTitulo listaCorte">Referencias Bancarias </td>
					<td align="center" valign="top">&nbsp;</td>
				</tr>
				<tr >
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td colspan="2"><cfoutput>#rsClienteDetallista.CDrefcredito#</cfoutput>
					<cfif Not Len(Trim(rsClienteDetallista.CDrefcredito))>No hay</cfif>
					</td>
					<td align="center" valign="top">&nbsp;</td>
					<td align="center" valign="top">&nbsp;</td>
					<td colspan="2" align="left" valign="top"><cfoutput>#rsClienteDetallista.CDrefbancaria#</cfoutput>
					<cfif Not Len(Trim(rsClienteDetallista.CDrefbancaria))>No hay</cfif>
					</td>
					<td align="center" valign="top">&nbsp;</td>
				</tr>
				<tr><td colspan="10">&nbsp;</td></tr>
				<tr >
					<td>&nbsp;</td>
					<td colspan="7" align="left" valign="top" nowrap class="subTitulo listaCorte" >Documentos Aportados</td>
					<td>&nbsp;</td>
				</tr>
				<tr><td colspan="10">&nbsp;</td></tr>
				<tr >
					<td align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;
					</td>
					<td align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td colspan="2" align="left" valign="top">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#documentos#"
						desplegar="CDDfecha, TDdescripcion, CDDvalidohasta"
						etiquetas="Fecha de registro, Tipo de Documento, Válido hasta"
						formatos="D,S,D"
						align="left,left,left"
						funcion="preview_docu" fparams="CDid,TDid,CDDid"
						keys="CDid,TDid,CDDid"
						maxrows="0"
						showemptylistmsg="true"
						totales="total"
						PageIndex="3">
					</cfinvoke>
					</td>
					<td align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
					<td colspan="3" align="left" valign="top"><img onClick="popup_doc(this.src)" name="img_preview" id="img_preview" src="blank.gif" border="0" width="300" height="100">&nbsp;</td>
					<td align="center" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
				</tr>
				<tr >
					<td colspan="9" align="center" valign="top">
						<!---<form action="Documentos-sql.cfm" enctype="multipart/form-data" method="post">--->
						<cfoutput>
						<form action="AprobarCliente-sql.cfm" method="post">
							<cfset Lvar_botones = 'Regresar'>
							<cfset Lvar_botonesval = 'Regresar'>
							<cfif rsClienteDetallista.CDactivo eq 'A'>
								<cfset Lvar_botones = Lvar_botones & ',statP, statI'>
								<cfset Lvar_botonesval = Lvar_botonesval & ',Proceso,Inactivar'>
							</cfif>
							<cfif rsClienteDetallista.CDactivo eq 'R'>
								<cfset Lvar_botones = Lvar_botones & ',statP'>
								<cfset Lvar_botonesval = Lvar_botonesval & ',Proceso'>
							</cfif>
							<cfif rsClienteDetallista.CDactivo neq 'A'>
								<cfset Lvar_botones = Lvar_botones & ',statA'>
								<cfset Lvar_botonesval = Lvar_botonesval & ',Aprobar'>
							</cfif>
							<cfif rsClienteDetallista.CDactivo neq 'R'>
								<cfset Lvar_botones = Lvar_botones & ',statR'>
								<cfset Lvar_botonesval = Lvar_botonesval & ',Rechazar'>
							</cfif>
							<cfif isdefined('form.Pagina')>
								<input name="Pagina" type="hidden" value="#form.Pagina#" tabindex="-1">
							</cfif>
							<cfif isdefined('form.Filtro_CDIdentificacion') and LEN(TRIM(form.Filtro_CDIdentificacion))>
								<input name="Filtro_CDIdentificacion" type="hidden" value="#form.Filtro_CDIdentificacion#" tabindex="-1">
							</cfif>
							<cfif isdefined('form.Filtro_CDnombre') and LEN(TRIM(form.Filtro_CDnombre))>
								<input name="Filtro_CDnombre" type="hidden" value="#form.Filtro_CDnombre#" tabindex="-1	">
							</cfif>
							<cfif isdefined('form.Filtro_rotulo') and LEN(TRIM(form.Filtro_rotulo))>
								<input name="Filtro_rotulo" type="hidden" value="#form.Filtro_rotulo#" tabindex="-1">
							</cfif>

						  <input type="hidden" name="CDid" value="#form.CDid#" tabindex="-1">
						  <input type="hidden" name="CDDid" value="#form.CDDid#" tabindex="-1">
						  Estado Actual del Cliente: <strong>#rsClienteDetallista.rotulo#</strong><br>
						<br>
						<cf_botones exclude="Alta,Limpiar" include="#Lvar_botones#" includevalues="#Lvar_botonesval#" tabindex="1">
						<!--- <input type="button" name="goback" value="&lt;&lt; Regresar" onClick="funcRegresar()">
						<cfif rsClienteDetallista.CDactivo eq 'A' or rsClienteDetallista.CDactivo eq 'R'><input type="submit" name="statP" value="Proceso"></cfif>
						<cfif rsClienteDetallista.CDactivo neq 'A'><input type="submit" name="statA" value="Aprobar"></cfif>
						<cfif rsClienteDetallista.CDactivo eq 'A' ><input type="submit" name="statI" value="Inactivar"></cfif>
						<cfif rsClienteDetallista.CDactivo neq 'R' ><input type="submit" name="statR" value="Rechazar"></cfif> --->
						</form>
						</cfoutput>							  
					
					</td>
				</tr>	
			</table>
	
			<script type="text/javascript">
			<!--
				function preview_docu (CDid,TDid,CDDid) {
					<cfoutput>
					var imagen = document.all ? document.all.img_preview : document.getElementById('img_preview');
					imagen.src = 'doc_blob.cfm?CDid=' + escape(CDid) + '&TDid=' + 
								escape(TDid) + '&CDDid=' + escape(CDDid);
					</cfoutput>
				}
				function funcRegresar() {
					<cfoutput>
					location.href = 'Documentos.cfm?CDid=#URLEncodedFormat(form.CDid)##params#';
					return false;
					</cfoutput>
				}
				var popUpWin = 0;
				function closePopUp(){
					if(popUpWin) {
						if(!popUpWin.closed) popUpWin.close();
						popUpWin = null;
					}
				}
				function popUpWindow(URLStr, left, top, width, height)
				{
					closePopUp();
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
					window.onfocus = closePopUp;
				}
				function popup_doc(src) {
					popUpWindow(src.replace('doc_blob','doc_show'), 300,150,400,400);
				}
			//-->
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>
