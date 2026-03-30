<!--- Este Árbol pinta 1 item y todos sus ancestros, y todos los items de la raíz --->
<!--- <cfparam name="form.CFpk" default="0" type="numeric"> --->
<!--- busqueda recursiva de los ancestros del item... se espera que los ancestros sean cuando mucho unos 4...  si son mas de 10 hay que cambiar esta solución. --->
<cfset litem = "0">
<cfset ruta  = "0">
<cfif isdefined("Form.CFpk")>
	<cfset litem = Form.CFpk>
	<cfset ruta =  Form.CFpk>
</cfif>
<cfset n=0>
<cfloop condition="litem neq 0 and n lt 50">
	<cfset n=n+1>
	<cfquery datasource="#session.dsn#" name="papa">
		select coalesce(CFidresp,0) as ancestro
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#litem#">
	</cfquery>
	<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & papa.ancestro>
	<cfset litem = papa.ancestro>
</cfloop>
<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & "0">

<!--- trae todos los items por pintar --->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery datasource="#session.dsn#" name="lista" maxrows="200">
	select c.CFid as item, rtrim(c.CFcodigo) #_Cat# ' - ' #_Cat# c.CFdescripcion as name, coalesce(c.CFidresp,0) as ancestro, 
		(select 
			count(*) from CFuncional h
			where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and h.CFidresp = c.CFid) as hijos
	from CFuncional c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and coalesce(CFidresp,0) in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta#" list="yes">)
	  and CFid != 0
</cfquery>

<script src="xtree-117.js"></script>
<link href="xtree-117.css" rel="stylesheet" type="text/css">
<div style="width: 350px; height: 550px; padding: 5px; overflow: auto;">
<script type="text/javascript">
<!--
	var imgraiz = "/cfmx/sif/imagenes/Web_Users.gif";
	var imgnormal = "/cfmx/sif/imagenes/usuario04_T.gif";
	var imgselec = "/cfmx/sif/imagenes/usuario01_T.gif";

	if (document.getElementById) {
		/*construye el WebFXTree*/
		var node0 = new WebFXTree('Centros Funcionales', 'CFuncional.cfm', 'explorer', imgraiz, imgraiz);
		/*crea los nodos*/
		<cfoutput query="lista">
			var node#item# =  new WebFXTreeItem('#name#', 'CFuncional.cfm?CFpk=#item#', '', 
			<cfif hijos gt 0>
			imgnormal,imgnormal
			<cfelse>
			imgselec,imgselec
			</cfif>
			);
			node#item#.open = true;
		</cfoutput>
		/*asocia los nodos con los padres*/
		<cfoutput query="lista">
			node#ancestro#.add(node#item#);
		</cfoutput>
		/*pinta el WebFXTree*/
		node0.open = true;
		document.write(node0);
		<cfif isdefined("Form.CFpk") and Len(trim(Form.CFpk))>
			node<cfoutput>#form.CFpk#</cfoutput>.select();
		</cfif>;
	}
//-->
</script>
</div>