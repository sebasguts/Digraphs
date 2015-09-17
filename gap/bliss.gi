#############################################################################
##
#W  bliss.gi
#Y  Copyright (C) 2014-15                                James D. Mitchell
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

# methods using bliss . . .

InstallMethod(DigraphCanonicalLabelling, "for a digraph",
[IsDigraph],
function(graph)

  if IsMultiDigraph(graph) then
    return MULTIDIGRAPH_CANONICAL_LABELING(graph);
  fi;
  return DIGRAPH_CANONICAL_LABELING(graph);
end);

#

InstallMethod(IsIsomorphicDigraph, "for digraphs",
[IsDigraph, IsDigraph],
function(g1, g2)

  # check some invariants
  if DigraphNrVertices(g1) <> DigraphNrVertices(g2)
      or DigraphNrEdges(g1) <> DigraphNrEdges(g2)
      or IsMultiDigraph(g1) <> IsMultiDigraph(g2) then
    return false;
  fi; #JDM more!

  if IsMultiDigraph(g1) then
    return OnMultiDigraphs(g1, DigraphCanonicalLabelling(g1))
      = OnMultiDigraphs(g2, DigraphCanonicalLabelling(g2));
  fi;
  return OnDigraphs(g1, DigraphCanonicalLabelling(g1))
    = OnDigraphs(g2, DigraphCanonicalLabelling(g2));
end);

#

InstallMethod(AutomorphismGroup, "for a digraph",
[IsDigraph],
function(graph)
  local x;

  if IsMultiDigraph(graph) then
    x := MULTIDIGRAPH_AUTOMORPHISMS(graph);
    SetDigraphCanonicalLabelling(graph, x[1]);
    return DirectProduct(Group(x[2]), Group(x[3]));
  fi;

  x := DIGRAPH_AUTOMORPHISMS(graph);
  SetDigraphCanonicalLabelling(graph, x[1]);
  if not HasDigraphGroup(graph) then 
    SetDigraphGroup(graph, Group(x[2]));
  fi;
  return Group(x[2]);
end);

#

InstallMethod(IsomorphismDigraphs, "for digraphs",
[IsDigraph, IsDigraph],
function(g1, g2)
  local label1, label2;

  if not IsIsomorphicDigraph(g1, g2) then
    return fail;
  fi;

  if IsMultiDigraph(g1) then
    label1 := DigraphCanonicalLabelling(g1);
    label2 := DigraphCanonicalLabelling(g2);
    return [label1[1] / label2[1], label1[2] / label2[2]];
  fi;

  return DigraphCanonicalLabelling(g1) / DigraphCanonicalLabelling(g2);
end);
