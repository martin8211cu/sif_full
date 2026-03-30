<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Historia"
	Default="Historia"
	returnvariable="LB_Historia"/>
﻿<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Dominio"
	Default="Dominio"
	returnvariable="LB_Dominio"/>


﻿<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
	<tr>
		<td  align="center" colspan="1">
				<cfchart 
						xAxisTitle="#LB_Historia#"
						yAxisTitle="#LB_Dominio#"
						showborder="no"
						show3d="yes"  format="png"
					> 
				
					<cfchartseries 
						type="line" 
						query="rsHistoria" 
						valueColumn="RHCEdominio" 
						itemColumn="RHCEfdesdet"
				
					/>
				</cfchart>
		 </td>
	</tr>		
</table>
