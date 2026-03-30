<cfset navegacion = "">
<!---En caso de que tipo sea =1--->

<cfquery name="rsQueryLista2" datasource="#session.dsn#">
    select Smes, Speriodo  
    from CGPeriodosProcesados 
    where Ecodigo = #session.ecodigo#
    order by Speriodo desc
</cfquery>	

<cfquery name="rsQueryLista" datasource="#session.dsn#">
select distinct

    ((	 select count(1)
         from CGParamConductores v
            inner join CGConductores con
            	on v.Ecodigo = con.Ecodigo
               and v.CGCid   = con.CGCid
         where v.CGCperiodo = a.Speriodo
           and v.CGCmes     = a.Smes
       ))  Suma,
    
    coalesce ((((
            select sum (CGCvalor)
            from CGParamConductores v
                inner join CGConductores con
                  on v.Ecodigo = con.Ecodigo
                 and v.CGCid   = con.CGCid
             where v.CGCperiodo = a.Speriodo
               and v.CGCmes     = a.Smes
                        
        ))),0) Total,
	Speriodo,
	Smes 
    from CGPeriodosProcesados a
    where Ecodigo = #session.ecodigo#
    order by a.Speriodo desc, Smes desc
</cfquery>

<table width="100%">		
	<tr>	
		<td width="50%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#rsQueryLista#"
				desplegar="Speriodo,Smes,Suma,Total"
				etiquetas="Periodo,Mes,Capturados,Total"
				formatos="S,S,S,M"
				align="left,left,left,left"
				ira="Valor_Conductor_listaC.cfm"
				showlink="true"
				form_method="post"
				showEmptyListMsg="yes"
				keys="Speriodo,Smes"	
				MaxRows="30"
				navegacion="#Navegacion#"
                PageIndex="1"	
				/>	
		</td>
	</tr>	
</table>

