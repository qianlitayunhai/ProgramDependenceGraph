module DataDependence::ReachingDefs
import lang::java::m3::AST;
import ADT;
import ControlDependence::ControlFlow;
import Utils::Map;
import Utils::ListRelation;
import IO;

public tuple[map[int, map[int, set[str]]] inputs, map[int, map[int, set[str]]] outputs] getReachingDefs(CF cf, map[int number, Statement stat] statements, map[str, set[int]] defs, map[int, set[str]] gens){
	map[int, map[int, set[str]]] kills = ();
	map[int, map[int, set[str]]] outputs = ();
	map[int, map[int, set[str]]] inputs = ();
	
	map[int, list[int]] preds = getPredecessors(cf.cflow);
	for(s <- statements){
		if(s in gens){
			kills[s] = ();
			for(var <- gens[s]){
				for(stat <- defs[var])
					kills[s] = insertInToMap(var, stat, kills[s]);
			} 
		}else{
			gens[s] = {};
			kills[s] = ();
		}
		//initialize outputs and inputs
		outputs[s]= (s: gens[s]);
		inputs[s] = ();
	}
	
	bool change = true;
	while(change){
		change = false;
		for(s <- statements){
			if(s in preds) inputs[s] = mergeMaps([outputs[p] | p <- preds[s]]);
			oldOut = outputs[s];
			outputs[s] = mergeMaps([(s: gens[s]), subtractMaps(inputs[s], kills[s])]);
			if(outputs[s] != oldOut) change = true;
		}
	}
	
	return <inputs, outputs>;
}