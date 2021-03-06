/*PGR-GNU*****************************************************************

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2016 Andrea Nardelli
mail: nrd.nardelli@gmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

********************************************************************PGR-GNU*/



/***********************************
        MANY TO MANY
***********************************/

CREATE OR REPLACE FUNCTION pgr_edgeDisjointPaths(
    TEXT,
    ANYARRAY,
    ANYARRAY,
    directed BOOLEAN DEFAULT TRUE,
    OUT seq INTEGER,
    OUT path_id INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT
    )
  RETURNS SETOF RECORD AS
 '${MODULE_PATHNAME}', 'edge_disjoint_paths_many_to_many'
    LANGUAGE c VOLATILE STRICT;

/***********************************
        ONE TO ONE
***********************************/

CREATE OR REPLACE FUNCTION pgr_edgeDisjointPaths(
    TEXT,
    bigint,
    bigint,
    directed BOOLEAN DEFAULT TRUE,
    OUT seq INTEGER,
    OUT path_id INTEGER,
    OUT path_seq INTEGER,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT
    )
  RETURNS SETOF RECORD AS
  $BODY$
    SELECT a.seq, a.path_id, a.path_seq, a.node, a.edge, a.cost, a.agg_cost
    FROM pgr_edgeDisjointPaths(_pgr_get_statement($1), ARRAY[$2]::BIGINT[], ARRAY[$3]::BIGINT[], $4) AS a;
  $BODY$
LANGUAGE sql VOLATILE STRICT;

/***********************************
        ONE TO MANY
***********************************/

CREATE OR REPLACE FUNCTION pgr_edgeDisjointPaths(
    TEXT,
    bigint,
    ANYARRAY,
    directed BOOLEAN DEFAULT TRUE,
    OUT seq INTEGER,
    OUT path_id INTEGER,
    OUT path_seq INTEGER,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT
    )
  RETURNS SETOF RECORD AS
  $BODY$
    SELECT a.seq, a.path_id, a.path_seq, a.end_vid, a.node, a.edge, a.cost, a.agg_cost
    FROM pgr_edgeDisjointPaths(_pgr_get_statement($1), ARRAY[$2]::BIGINT[], $3::BIGINT[], $4) AS a;
  $BODY$
LANGUAGE sql VOLATILE STRICT;

/***********************************
        MANY TO ONE
***********************************/

CREATE OR REPLACE FUNCTION pgr_edgeDisjointPaths(
    TEXT,
    ANYARRAY,
    BIGINT,
    IN directed BOOLEAN DEFAULT TRUE,
    OUT seq INTEGER,
    OUT path_id INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT
    )
  RETURNS SETOF RECORD AS
  $BODY$
    SELECT a.seq, a.path_id, a.path_seq, a.start_vid, a.node, a.edge, a.cost, a.agg_cost
    FROM pgr_edgeDisjointPaths(_pgr_get_statement($1), $2::BIGINT[], ARRAY[$3]::BIGINT[], $4) AS a;
  $BODY$
LANGUAGE sql VOLATILE STRICT;
