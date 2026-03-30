<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">Seleccione una tienda</cf_templatearea>
<cf_templatearea name="header"></cf_templatearea>
<cf_templatearea name="left"></cf_templatearea>
<cf_templatearea name="body">

<cfquery datasource="asp" name="listado_de_tiendas">
select distinct 
	convert(varchar, Ereferencia) as Ecodigo, 
	e.Enombre as nombre, c.Ccache, datalength(e.Elogo) as sz_logo
from Empresa e, Caches c
where e.Cid = c.Cid
  and exists (select * from UsuarioProceso up where up.Ecodigo = e.Ecodigo and up.SScodigo = 'TIENDA')
order by sign(datalength(e.Elogo)) desc,
	nombre, Ecodigo
</cfquery>

<style type="text/css">
.cuadro {
	border: none;
	background-color: #f8f8f8;
}
</style>

<table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr>
    <td valign="top">
    <cfoutput query="listado_de_tiendas"><cfif sz_logo GT 0>
		<a href="index.cfm?ctid=#Ecodigo#">
	    <img src="tienda_img.cfm?id=#Ecodigo#" alt="#nombre#" height="120" border="0">
		</a></cfif>
    </cfoutput>
    </td></tr>
    <cfoutput query="listado_de_tiendas"><cfif sz_logo EQ 0>
		<tr><td valign="top">
		*
			<a href="index.cfm?ctid=#Ecodigo#" style="text-decoration:none">
			#nombre#
			</a>
		</td></tr>
	</cfif>
    </cfoutput>
</table>

</cf_templatearea>
</cf_template>
