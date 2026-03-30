<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 24-10-2005.
		Motivo: Se modifica para que conserve los valores del filtro. Se elimina Ã³ como caracter que aparecía en 
		las etiquetas del filtro en el conlis. Se cambia el pintado de la lista para que utilice el pListaQuery y
		así corregir la navegación por que antes se pintaba a pie.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 16-11-2005.
		Motivo: se limita a 10 la lista.
 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Lista de Cuentas Bancarias" returnvariable="LB_Titulo" xmlfile="ConlisCuentasBancarias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" xmlfile="ConlisCuentasBancarias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="ConlisCuentasBancarias.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Filtrar" default="Filtrar" returnvariable="BTN_Filtrar" xmlfile="ConlisCuentasBancarias.xml"/>

<html>
<head>
<title><cfoutput>#LB_Titulo#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!---LvarTCEstadosCuenta--->

<cfset LvarCBesTCE = 0>
<cfif isdefined("LvarTCEstadosCuenta") or isdefined("LvarConlisCuentasBancarias")>
<cfset LvarCBesTCE = 1>
</cfif>

<cf_templatecss>
</head>
<cfif isdefined("url.CBcodigo") and len(trim(url.CBcodigo)) and not isdefined("form.CBcodigo")>
	<cfset form.CBcodigo = url.CBcodigo>
</cfif>
<cfif isdefined("url.CBdescripcion") and len(trim(url.CBdescripcion)) and not isdefined("form.CBdescripcion")>
	<cfset form.CBdescripcion = url.CBdescripcion>
</cfif>

<cfquery name="conlis" datasource="#Session.DSN#">	
	select a.CBid, a.CBcodigo, a.CBdescripcion, b.Mnombre, 
		case when a.Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.monedaLocal#">
				then 0.0000 else 1.0000 end as TipoCambio, 
		a.Mcodigo,
		g.Bdescripcion

	from CuentasBancos a
		inner join Monedas b
			on a.Mcodigo = b.Mcodigo  
		inner join Bancos g
			on a.Bid = g.Bid
	
	where   a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
    	and a.CBesTCE = #LvarCBesTCE#
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		<!----and  a.CBid not in (
	  						Select c.Bid
							from 	ECuentaBancaria d 
									inner join Bancos e
										on d.Bid = e.Bid 
									inner join CuentasBancos c
	  									on d.CBid = c.CBid
							where 	e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            		and c.CBesTCE = #LvarCBesTCE# 
									and d.ECaplicado = 'N' 
									and d.EChistorico = 'N'
	    )---->
        <cfif LvarCBesTCE eq 1 and url.filtro eq 1>
            and a.CBTCid in (	
                                select CBTCid  
                                from CBDusuarioTCE cd
                                    inner join CBUsuariosTCE cbu
                                        on cbu.CBUid = cd.CBUid
                                where cbu.Usucodigo= #Session.Usucodigo# 
                                and cd.CBDUmovimientos = 1
                            )
		</cfif>
	<!--- isdefined("Form.Filtrar")and --->
	<cfif isdefined("Form.CBcodigo") and Len(Trim(Form.CBcodigo))>
	  and upper(a.CBcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Form.CBcodigo)#%">
	</cfif><!--- isdefined("Form.Filtrar") and --->
	<cfif isdefined("Form.CBdescripcion") and 	 Len(Trim(Form.CBdescripcion))>
	  and upper(a.CBdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Form.CBdescripcion)#%">
	</cfif>
	order by a.CBcodigo, a.CBdescripcion 
</cfquery>

<script language="JavaScript1.2">
function Asignar(valor1, valor2, valor3, valor4, valor5) {
	window.opener.document.<cfoutput>#url.form#.#url.id#</cfoutput>.value=valor1;	
	window.opener.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value=valor2;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Mcodigo.value=valor3;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.Mnombre.value=valor4;
	window.opener.document.<cfoutput>#url.form#</cfoutput>.ECtipocambio.value=valor5;			
	window.close();
	limpiar();
}

function limpiar() {
	if (window.opener.document.<cfoutput>#url.form#</cfoutput>.ECid.value != "") {
        window.opener.document.<cfoutput>#url.form#</cfoutput>.DCtipocambio.disabled = false;

        // deshabilita el tipo de cambio cuando la moneda de la cuenta origen es = a la moneda local
       if (<cfoutput>#url.monedaLocal#</cfoutput> == window.opener.document.<cfoutput>#url.form#</cfoutput>.Mcodigo.value) 
            window.opener.document.<cfoutput>#url.form#</cfoutput>.DCtipocambio.disabled = true;       
       else 
           window.opener.document.<cfoutput>#url.form#</cfoutput>.DCtipocambio.disabled = false;       
	}
}

</script>

<body>
<form action="" method="post" name="conlis">
  <table width="53%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="44%" class="tituloListas"><div align="left"><cfoutput>#LB_Codigo#</cfoutput></div></td>
      <td width="28%" class="tituloListas"><div align="left"><cfoutput>#LB_Descripcion#</cfoutput></div></td>
      <td width="1%" class="tituloListas"><div align="right"> 
          <input type="submit" name="Filtrar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
          </div></td>
    </tr>
    <tr> 
      <td><input name="CBcodigo" type="text" value="<cfif isdefined("form.CBcodigo") and len(trim(form.CBcodigo))><cfoutput>#form.CBcodigo#</cfoutput></cfif>" size="40" maxlength="100"></td>
      <td colspan="2"><input name="CBdescripcion" type="text" value="<cfif isdefined("form.CBdescripcion") and len(trim(form.CBdescripcion))><cfoutput>#form.CBdescripcion#</cfoutput></cfif>" size="40" maxlength="60"></td>
    </tr>
	<tr>
		<td colspan="3">
		<cfset navegacion = "">
		<cfoutput>
		  	 <cfif isdefined ("form.CBcodigo") and len(trim(form.CBcodigo))>
		  		<cfset navegacion = navegacion & "&CBcodigo=#form.CBcodigo#">
			</cfif>
			<cfif isdefined ("form.CBdescripcion") and len(trim(form.CBdescripcion))>
		  		<cfset navegacion = navegacion & "&CBdescripcion=#form.CBdescripcion#">
			</cfif>
		</cfoutput>
		<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td>
		<cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
		  <cfinvokeargument name="query"  				value="#conlis#"/>
		  <cfinvokeargument name="desplegar"  			value="CBcodigo, CBdescripcion"/>
		  <cfinvokeargument name="etiquetas"  			value="#LB_Codigo#, #LB_Descripcion#"/>
		  <cfinvokeargument name="formatos"   			value="S,S"/>
		  <cfinvokeargument name="align"      			value="left,left"/>
		  <cfinvokeargument name="ajustar"    			value="S"/>
		  <cfinvokeargument name="MaxRows"    			value="10"/>
		  <cfinvokeargument name="funcion"    			value="Asignar"/>
		  <cfinvokeargument name="fparams"        		value="CBid, CBdescripcion, Mcodigo, Mnombre, TipoCambio"/>
		  <cfinvokeargument name="irA"        			value=""/>
		  <cfinvokeargument name="navegacion" 			value="#navegacion#"/>
		  <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		  <cfinvokeargument name="keys"             	value="CBcodigo"/>
		</cfinvoke>
				</td>
			</tr>
		</table> <div align="center"> </div></td>
    </tr>
  </table>
</form>
</body>
</html>
<!----
	select a.CBid, a.CBcodigo, a.CBdescripcion, b.Mnombre, 
		case when a.Mcodigo != <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.monedaLocal#">
			then 0.0000 else 1.0000 end as TipoCambio, 
		a.Mcodigo,
		g.Bdescripcion
	from CuentasBancos a, Monedas b, Bancos g
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	  and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> 
	  and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Bid#"> 
	  and a.Mcodigo = b.Mcodigo  
	  and a.Bid = g.Bid
	  and a.CBid not in (
	  	Select c.Bid from ECuentaBancaria d, Bancos e, CuentasBancos c
	  	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
		  and d.Bid = e.Bid and d.CBid = c.CBid and d.ECaplicado = 'N' and d.EChistorico = 'N'
	)
----->

