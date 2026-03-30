<cfinvoke Key="LBNombre" Default="Nombre" XmlFile="/rh/generales.xml" returnvariable="LBNombre" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBPApellido" Default="Primer Apellido" XmlFile="/rh/generales.xml" returnvariable="LBPApellido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBSApellido" Default="Segundo Apellido" XmlFile="/rh/generales.xml" returnvariable="LBSApellido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBTipoI" Default="Tipo Identificación" XmlFile="/rh/generales.xml" returnvariable="LBTipoI" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBIdentif" Default="Identificación" XmlFile="/rh/generales.xml" returnvariable="LBIdentif" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBNumSS" Default="Num.Seguro Social" XmlFile="/rh/generales.xml" returnvariable="LBNumSS" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBEstado" Default="Estado Civil" XmlFile="/rh/generales.xml" returnvariable="LBEstado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBFecha" Default="Fecha de Nacimiento" XmlFile="/rh/generales.xml" returnvariable="LBFecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBSexo" Default="Sexo" XmlFile="/rh/generales.xml" returnvariable="LBSexo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBDireccion" Default="Dirección" XmlFile="/rh/generales.xml" returnvariable="LBDireccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBRuta" Default="Ruta de Foto" XmlFile="/rh/generales.xml" returnvariable="LBRuta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBCuenta" Default="Cuenta" XmlFile="/rh/generales.xml" returnvariable="LBCuenta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBBanco" Default="Banco" XmlFile="/rh/generales.xml" returnvariable="LBBanco" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBTipo" Default="Tipo de Cuenta" XmlFile="/rh/generales.xml" returnvariable="LBTipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBMail" Default="Dirección Electrónica" XmlFile="/rh/generales.xml" returnvariable="LBMail" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBCCliente" Default="Cuenta Cliente" XmlFile="/rh/generales.xml" returnvariable="LBCCliente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBMoneda" Default="Moneda" XmlFile="/rh/generales.xml" returnvariable="LBMoneda" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBTelR" Default="Teléfono de Residencia" XmlFile="/rh/generales.xml" returnvariable="LBTelR" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBTelC" Default="Teléfono Celular" XmlFile="/rh/generales.xml" returnvariable="LBTelC" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBIdT" Default="Id de Tarjeta" XmlFile="/rh/generales.xml" returnvariable="LBIdT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBPass" Default="Contraseña" XmlFile="/rh/generales.xml" returnvariable="LBPass" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBPais" Default="País de Nacimiento" XmlFile="/rh/generales.xml" returnvariable="LBPais" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBZona" Default="Zona Económica" XmlFile="/rh/generales.xml" returnvariable="LBZona" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LBDatosV" Default="Datos Variables" XmlFile="/rh/generales.xml" returnvariable="LBDatosV" component="sif.Componentes.Translate" method="Translate"/>


<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">


<cfquery name="rsform" datasource="#session.dsn#">
	select Ecodigo,Bid, NTIcodigo, DEidentificacion, 
			DEnombre, DEapellido1, DEapellido2, 
			CBTcodigo, DEcuenta, CBcc, 
			Mcodigo, DEdireccion, DEtelefono1, 
			DEtelefono2, DEemail, DEcivil,
			DEfechanac, DEsexo, DEcantdep, 
			DEtarjeta, 
			DEpassword, Ppais, DESeguroSocial,			
			ZEid, DEsdi, 
			DEobs1, DEobs2, DEobs3,
			DEobs4, DEobs5,DEdato1,
			DEdato2, DEdato3, DEdato4, 
		    DEdato5,DEdato6, DEdato7, 
			DEinfo1, DEinfo2, DEinfo3,
			DEinfo4, DEinfo5, FEdatos1,
  			FEdatos2,FEdatos3,FEinfo1,FEinfo2,FEobs1, FEobs2  ,    
			BMUsucodigo, DEruta,
			BMfechaalta
	from DEModificables
	where Ecodigo=#session.Ecodigo#
</cfquery>
	
<cfoutput>
<form name="fDEmod" action="DEmodificable_sql.cfm" method="post">
<table width="100%">
	<tr>
		<td>
			<input type="checkbox" name="DEnombre" <cfif rsform.DEnombre eq 1> checked="checked"</cfif>>#LBNombre#
		</td>
		<td>
			<input type="checkbox" name="PApellido" <cfif rsform.DEapellido1 eq 1> checked="checked"</cfif>>#LBPApellido#
		</td>
			<td>
			<input type="checkbox" name="SApellido"  <cfif rsform.DEapellido2 eq 1> checked="checked"</cfif>>#LBSApellido#
		</td>
	</tr>	
	<tr>
		<td>
			<input type="checkbox" name="TipoI"  <cfif rsform.NTIcodigo eq 1> checked="checked"</cfif>>#LBTipoI#
		</td>
		<td>
			<input type="checkbox" name="Identif"  <cfif rsform.DEidentificacion eq 1> checked="checked"</cfif>>#LBIdentif#
		</td>
			<td>
			<input type="checkbox" name="NumSS"  <cfif rsform.DESeguroSocial eq 1> checked="checked"</cfif>>#LBNumSS#
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="Estado" <cfif rsform.DEcivil eq 1> checked="checked"</cfif>>#LBEstado#
		</td>
		<td>
			<input type="checkbox" name="Fecha" <cfif rsform.DEfechanac eq 1> checked="checked"</cfif>>#LBFecha#
		</td>
			<td>
			<input type="checkbox" name="Sexo" <cfif rsform.DEsexo eq 1> checked="checked"</cfif>>#LBSexo#
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="Direccion" <cfif rsform.DEdireccion eq 1> checked="checked"</cfif>>#LBDireccion#
		</td>
		<td>
			<input type="checkbox" name="Ruta" <cfif rsform.DEruta eq 1> checked="checked"</cfif>>#LBRuta#
		</td>
			<td>
			<input type="checkbox" name="Cuenta" <cfif rsform.DEcuenta eq 1> checked="checked"</cfif>>#LBCuenta#
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="Banco" <cfif rsform.Bid eq 1> checked="checked"</cfif>>#LBBanco#
		</td>
		<td>
			<input type="checkbox" name="Tipo" <cfif rsform.CBTcodigo eq 1> checked="checked"</cfif>>#LBTipo#
		</td>
			<td>
			<input type="checkbox" name="Mail" <cfif rsform.DEemail eq 1> checked="checked"</cfif>>#LBMail#
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="CCliente" <cfif rsform.CBcc eq 1> checked="checked"</cfif>>#LBCCliente#
		</td>
		<td>
			<input type="checkbox" name="Moneda" <cfif rsform.Mcodigo eq 1> checked="checked"</cfif>>#LBMoneda#
		</td>
			<td>
			<input type="checkbox" name="TelR" <cfif rsform.DEtelefono1 eq 1> checked="checked"</cfif>>#LBTelR#
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="TelC" <cfif rsform.DEtelefono2 eq 1> checked="checked"</cfif>>#LBTelC#
		</td>
		<td>
			<input type="checkbox" name="IdT" <cfif rsform.DEtarjeta eq 1> checked="checked"</cfif>>#LBIdT#
		</td>
			<td>
			<input type="checkbox" name="Pass" <cfif rsform.DEpassword eq 1> checked="checked"</cfif>>#LBPass#
		</td>
	</tr>
	<tr>
		<td>
			<input type="checkbox" name="Pais" <cfif rsform.Ppais eq 1> checked="checked"</cfif>>#LBPais#
		</td>
		<td>
			<input type="checkbox" name="Zona" <cfif rsform.ZEid eq 1> checked="checked"</cfif>>#LBZona#
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		 <td colspan="3" class="#Session.preferences.Skin#_thcenter" style="padding-left: 5px;" align="center">#LBDatosV#</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<cfquery name="rsEE" datasource="#session.dsn#">	
		select e.RHEcol,e.RHEtiqueta 
		from RHEtiquetasEmpresa e
		where e.RHdisplay=1 and e.Ecodigo=#session.Ecodigo#
	</cfquery>
	
	<cfloop query="rsEE">
		<cfset LvarCol=''>	
		<cfset LvarCol1=''>	
		<cfset LvarCol=rsEE.RHEcol>
		<cfset LvarCol1='rsform.'&LvarCol>
	
		<tr>
			<td>
				<input type="checkbox" name="#rsEE.RHEcol#"  <cfif #evaluate(#LvarCol1#)# eq 1> checked="checked"</cfif>>#rsEE.RHEtiqueta#
			</td>
		</tr>
	</cfloop>
	<tr><td align="center" colspan="3"><cf_botones names="Aplicar" values="Aplicar"></td></tr>
</table>
</form>
</cfoutput>