import React from 'react';
import { Entity, CompositeDecorator } from 'draft-js';
import MultiDecorator from 'draft-js-multidecorators';
import PrismDecorator from 'draft-js-prism';
// import styles from './styles';

const Link = (props) => {
  const { url } = Entity.get(props.entityKey).getData();

  return (
    <a href={ url }>
      { props.children }
    </a>
  );
};


function findLinkEntities(contentBlock, callback) {
  contentBlock.findEntityRanges(
    (character) => {
      const entityKey = character.getEntity();
      return (
        entityKey !== null &&
        Entity.get(entityKey).getType() === 'LINK'
      );
    },
    callback
  );
}

export const decorator = new MultiDecorator([
  // default is javascript;
  new PrismDecorator({
    defaultSyntax: 'javascript'
  }),
  new CompositeDecorator([
    {
      strategy: findLinkEntities,
      component: Link
    }
  ])
]);
